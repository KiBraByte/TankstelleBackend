package htl.it.brs.controller;

import htl.it.brs.database.callable.FCountTankkarten;
import htl.it.brs.database.callable.SPProduktTankkarteZuordnen;
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
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

public class TankkartenAnlegenController extends Controller {
    private static final String DEFAULT_PRODUCT_NAME = "Diesel";

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
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_401_NOT_AUTHORIZED, "Not authorized");
        }

        if (!req.getBody().containsKey("kundenNr")) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "kundenNr not found!");
        }

        try {
            dbConnection.getCon().setAutoCommit(false);
            int kundenNr = Integer.parseInt(req.getBody().get("kundenNr"));

            int jahreGueltig = containsAndNotEmpty(req,"jahreGueltig") ? Integer.parseInt(req.getBody().get("jahreGueltig")) : DEFAULT_JAHRE_GUELITIGKEIT;
            Date bis = Date.valueOf(LocalDate.now().plusYears(jahreGueltig));

            BigDecimal limit = containsAndNotEmpty(req, "limit") ? new BigDecimal(req.getBody().get("limit")) : new BigDecimal(DEFAULT_LIMIT);

            int anzahlKarten =  containsAndNotEmpty(req, "anzahlKarten") ? Integer.parseInt(req.getBody().get("anzahlKarten")) : DEFAULT_ANZAHL;

            String produkteStr = containsAndNotEmpty(req, "produkte") ? req.getBody().get("produkte") : DEFAULT_PRODUCT_NAME;

            String[] produkte = produkteStr.split(",");

            System.out.println(Arrays.toString(produkte));

            List<String> pans = new ArrayList<>();
            for (int i = 0; i < anzahlKarten; ++i) {
                String pan = calcPAN(kundenNr);

                new SPTankkarteAnlegen(dbConnection, kundenNr, pan, bis, limit).call();

                for (String produkt : produkte) {
                    int pResult = new SPProduktTankkarteZuordnen(dbConnection, pan, produkt.replaceAll("_", " ")).call();
                    if (pResult != 0) {
                        String msg = pResult >= TankkartenStatus.values().length ? "Unknown" : TankkartenStatus.values()[pResult].msg;
                        throw new Exception(msg);
                    }
                }

                pans.add(pan);
            }

            return res.setStatus(HTTPStatus.SUCCESS_201_CREATED).send(String.format("{\"msg\": [%s]}",
                    pans.stream().map(s -> String.format("\"%s\"", s)).collect(Collectors.joining(","))));

        } catch (Exception e) {
            try {
                dbConnection.getCon().rollback();
            } catch (SQLException ignored) {}

            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, e.getMessage());
        } finally {
            try {
                dbConnection.getCon().commit();
                dbConnection.getCon().setAutoCommit(true);
            } catch (SQLException ignored) {}
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

    private enum TankkartenStatus {
        SUCCESS("SUCCESS"),
        CARD_EXPIRED("Product not found!"),
        CARD_DISABLED("PAN not found!");

        private final String msg;

        TankkartenStatus(String msg) {
            this.msg = msg;
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
