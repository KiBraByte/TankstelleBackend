package htl.it.controller;

import htl.it.database.callable.SPKundeAnlegen;
import htl.it.database.dbconnection.DBConnection;
import http.server.implementation.common.status.HTTPStatus;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.request.HTTPRequest;
import http.server.implementation.response.ResponseBuilder;

import java.math.BigDecimal;
import java.util.HashMap;

public class KundenAnlegenController extends Controller {
    private static final int DEFAULT_LIMIT = 5000;

    public KundenAnlegenController(DBConnection dbConnection) {
        super(dbConnection);
    }

    @Override
    public ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param) {
        if (!req.getBody().containsKey("firmenname")){
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "No firmenname found!");
        }

        try {

            boolean status = !req.getBody().containsKey("status") || Boolean.parseBoolean(req.getBody().get("status"));
            BigDecimal limit = req.getBody().containsKey("limit") ? new BigDecimal(req.getBody().get("limit")) : new BigDecimal(DEFAULT_LIMIT);

            Integer insertedID = new SPKundeAnlegen(super.dbConnection, req.getBody().get("firmenname"), status, limit).call();

            if (insertedID == null) {
                throw new Exception("Could not insert!");
            } else {
                return res.setStatus(HTTPStatus.SUCCESS_201_CREATED).send(String.format("{\"kundenNr\": %d}", insertedID));
            }

        } catch (Exception e) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, e.getMessage());
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
}
