package htl.it.controller;

import htl.it.database.callable.SPBerechneAbrechnung;
import htl.it.database.dbconnection.DBConnection;
import htl.it.database.model.AccountRole;
import http.server.implementation.common.status.HTTPStatus;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.request.HTTPRequest;
import http.server.implementation.response.ResponseBuilder;

import java.sql.Date;
import java.util.HashMap;

public class AbrechnungsController extends Controller {
    public AbrechnungsController(DBConnection dbConnection) {
        super(dbConnection);
    }

    @Override
    public ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param) {

        if (!super.hasRequiredPermissions(req)) {
            return super.buildErrorResponse(res, HTTPStatus.REDIRECT_302_TEMP, "Not autherized");
        }

        if (!req.getBody().containsKey("begindatum") || !req.getBody().containsKey("enddatum")) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "One or more dates are missing!");
        }

        try {

            Date beginDate = Date.valueOf(req.getBody().get("begindatum"));
            Date endDate = Date.valueOf(req.getBody().get("enddatum"));

            Integer insertedAbrechnung = new SPBerechneAbrechnung(dbConnection, beginDate, endDate).call();

            if (insertedAbrechnung == null) {
                return super.buildErrorResponse(res, HTTPStatus.SERVER_ERR_500_GENERAL, "...");
            } else {
                return res.setStatus(HTTPStatus.SUCCESS_201_CREATED).send(String.format("{\"insertedAbrechnung\": \"%d\", \"msg\": \"%s\"}",
                        insertedAbrechnung, "Success!"));
            }

        } catch (Exception e) {
            System.out.println(e);
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "Dates are formatted incorrectly!");
        }
    }

    @Override
    public String getRoute() {
        return "/api/abrechnung";
    }

    @Override
    public HTTPMethod getHTTPMethod() {
        return HTTPMethod.POST;
    }

    @Override
    public AccountRole getRequiredRole() {
        return AccountRole.NONE;
    }
}
