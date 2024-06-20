package htl.it.controller;

import htl.it.database.callable.FCountTankkarten;
import htl.it.database.callable.SPTankkarteAnlegen;
import htl.it.database.dbconnection.DBConnection;
import htl.it.utilities.ChecksumUtilities;
import http.server.implementation.common.status.HTTPStatus;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.request.HTTPRequest;
import http.server.implementation.response.ResponseBuilder;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

public class TankkartenAnlegenController extends Controller {

    private static final String ISSUER_ID = "700093";
    private static final int DEFAULT_ANZAHL = 1;
//    private static final String DEFAULT_PRODUKTE = "Diesel";
    private static final int DEFAULT_JAHRE_GUELITIGKEIT = 1;

    private static final int DEFAULT_LIMIT = 1000;

    public TankkartenAnlegenController(DBConnection dbConnection) {
        super(dbConnection);
    }

    @Override
    public ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param) {
        if (!req.getBody().containsKey("kundenNr")) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "kundenNr not found!");
        }

        try {
            int kundenNr = Integer.parseInt(req.getBody().get("kundenNr"));
            String pan = this.calcPAN(kundenNr);

            //TODO: Produkte
//            List<String> produkte = new ArrayList<>();
//
//            if (req.getBody().containsKey("produkte")) {
//                String[] p = req.getBody().get("produkte").split("[\\[\\],]");
//                produkte.addAll(Arrays.asList(p));
//            } else {
//                produkte.add(DEFAULT_PRODUKTE);
//            }

            int jahreGueltig = req.getBody().containsKey("jahreGueltig") ? Integer.parseInt(req.getBody().get("jahreGueltig")) : DEFAULT_JAHRE_GUELITIGKEIT;
            Date bis = Date.valueOf(LocalDate.now().plusYears(jahreGueltig));

            BigDecimal limit = req.getBody().containsKey("limit") ? new BigDecimal(req.getBody().get("limit")) : new BigDecimal(DEFAULT_LIMIT);

            int anzahlKarten = req.getBody().containsKey("anzahlKarten") ? Integer.parseInt(req.getBody().get("anzahlKarten")) : DEFAULT_ANZAHL;

            List<String> pans = new ArrayList<>();
            for (int i = 0; i < anzahlKarten; ++i) {
                new SPTankkarteAnlegen(dbConnection, kundenNr, pan, bis, limit).call();
                pans.add(pan);
                pan = calcPAN(kundenNr);
            }


            return res.setStatus(HTTPStatus.SUCCESS_201_CREATED).send(String.format("{\"msg\": [%s]}",
                    pans.stream().map(s -> String.format("\"%s\"", s)).collect(Collectors.joining(","))));

        } catch (Exception e) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, e.getMessage());
        }
    }


    private String calcPAN(int kundenNr) throws Exception {
        int tankkartenCount = new FCountTankkarten(dbConnection, kundenNr).call() + 1;

        StringBuilder sb = new StringBuilder();
        sb.append(String.format("%s%06d%04d", ISSUER_ID, kundenNr, tankkartenCount));

        Optional<Integer> luhnDigit = ChecksumUtilities.useLuhnAlgo(sb.toString());

        if (luhnDigit.isPresent()) {
            return sb.append("-").append(luhnDigit.get()).toString();
        } else {
            throw new Exception("Invalid PAN!");
        }
    }


    @Override
    public String getRoute() {
        return "/api/tankkarteanlegen";
    }

    @Override
    public HTTPMethod getHTTPMethod() {
        return HTTPMethod.POST;
    }
}
