package htl.it.brs.controller;

import htl.it.brs.database.callable.SPCreateUserAccount;
import htl.it.brs.database.callable.SPKundeAnlegen;
import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.AccountRole;
import http.server.implementation.common.status.HTTPStatus;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.request.HTTPRequest;
import http.server.implementation.response.ResponseBuilder;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;

public class KundenAnlegenController extends Controller {
    private static final int DEFAULT_LIMIT = 5000;

    public KundenAnlegenController(DBConnection dbConnection) {
        super(dbConnection);
    }

    @Override
    public ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param) {

        if (super.requiresHigherPermissions(req)) {
            return super.buildErrorResponse(res, HTTPStatus.REDIRECT_302_TEMP, "Not authorized");
        }

        if (!req.getBody().containsKey("firmenname") || !req.getBody().containsKey("userName") || !req.getBody().containsKey("password")) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "No firmenname found!");
        }

        try {
            dbConnection.getCon().setAutoCommit(false);
            boolean status = !req.getBody().containsKey("status") || req.getBody().get("status").isEmpty() || Boolean.parseBoolean(req.getBody().get("status")) || "1".equals(req.getBody().get("status"));
            BigDecimal limit = super.containsAndNotEmpty(req, "limit") ? new BigDecimal(req.getBody().get("limit")) : new BigDecimal(DEFAULT_LIMIT);
            String userName = req.getBody().get("userName");
            String password = req.getBody().get("password");

            Integer insertedID = new SPKundeAnlegen(super.dbConnection, req.getBody().get("firmenname"), status, limit).call();


            if (insertedID == null) {
                throw new Exception("Could not insert!");
            } else {
                boolean wasSuccessful = new SPCreateUserAccount(super.dbConnection, userName, password, insertedID).call() == 0;
                if (!wasSuccessful) {
                    throw new Exception("UserAccount could not be created!");
                }
                return res.setStatus(HTTPStatus.SUCCESS_201_CREATED).send(String.format("{\"kundenNr\": %d}", insertedID));
            }

        } catch (Exception e) {
            try {
                dbConnection.getCon().rollback();
            } catch (SQLException ignored) {
            }
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, e.getMessage());
        } finally {
            try {
                dbConnection.getCon().commit();
                dbConnection.getCon().setAutoCommit(true);
            } catch (SQLException ignored) {
            }
        }
    }

    @Override
    public String getRoute() {
        return "/api/kundeanlegen";
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
