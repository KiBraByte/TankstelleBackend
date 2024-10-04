package htl.it.brs.controller;

import htl.it.brs.database.callable.FCountTankkarten;
import htl.it.brs.database.callable.SPTankkarteAnlegen;
import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.AccountRole;
import htl.it.brs.utilities.ChecksumUtilities;
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
    private static final int DEFAULT_JAHRE_GUELITIGKEIT = 1;

    private static final int DEFAULT_LIMIT = 1000;

    public TankkartenAnlegenController(DBConnection dbConnection) {
        super(dbConnection);
    }

    @Override
    public ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param) {
        if (super.requiresHigherPermissions(req)) {
            return super.buildErrorResponse(res, HTTPStatus.REDIRECT_302_TEMP, "Not authorized");
        }

        if (!req.getBody().containsKey("kundenNr")) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "kundenNr not found!");
        }

        try {
            int kundenNr = Integer.parseInt(req.getBody().get("kundenNr"));

            int jahreGueltig = containsAndNotEmpty(req,"jahreGueltig") ? Integer.parseInt(req.getBody().get("jahreGueltig")) : DEFAULT_JAHRE_GUELITIGKEIT;
            Date bis = Date.valueOf(LocalDate.now().plusYears(jahreGueltig));

            BigDecimal limit = containsAndNotEmpty(req, "limit") ? new BigDecimal(req.getBody().get("limit")) : new BigDecimal(DEFAULT_LIMIT);

            int anzahlKarten =  containsAndNotEmpty(req, "anzahlKarten") ? Integer.parseInt(req.getBody().get("anzahlKarten")) : DEFAULT_ANZAHL;

            List<String> pans = new ArrayList<>();
            for (int i = 0; i < anzahlKarten; ++i) {
                String pan = calcPAN(kundenNr);
                new SPTankkarteAnlegen(dbConnection, kundenNr, pan, bis, limit).call();
                pans.add(pan);
            }

            return res.setStatus(HTTPStatus.SUCCESS_201_CREATED).send(String.format("{\"msg\": [%s]}",
                    pans.stream().map(s -> String.format("\"%s\"", s)).collect(Collectors.joining(","))));

        } catch (Exception e) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "Error!");
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

    @Override
    public AccountRole getRequiredRole() {
        return AccountRole.BACKOFFICE;
    }
}
