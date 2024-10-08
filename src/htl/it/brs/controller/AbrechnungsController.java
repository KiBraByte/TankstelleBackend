package htl.it.brs.controller;

import htl.it.brs.database.callable.SPCreateAbrechnung;
import htl.it.brs.database.callable.SPGetAbrechnung;
import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.AbrechnungsArr;
import htl.it.brs.database.model.AccountRole;
import http.server.implementation.common.status.HTTPStatus;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.request.HTTPRequest;
import http.server.implementation.response.ResponseBuilder;

import java.util.Arrays;
import java.util.HashMap;

public class AbrechnungsController extends Controller {
    public AbrechnungsController(DBConnection dbConnection) {
        super(dbConnection);
    }

    @Override
    public ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param) {
        if (super.requiresHigherPermissions(req))
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_401_NOT_AUTHORIZED, "Not authorized");

        String[] requiredFields = new String[] {
            "beginMonth", "beginYear", "endMonth", "endYear"
        };

        if (!req.getBody().keySet().containsAll(Arrays.asList(requiredFields))) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "Fields missing!");
        }

        try {
            int beginMonth = Integer.parseInt(req.getBody().get("beginMonth"));
            int beginYear = Integer.parseInt(req.getBody().get("beginYear"));
            int endMonth = Integer.parseInt(req.getBody().get("endMonth"));
            int endYear = Integer.parseInt(req.getBody().get("endYear"));

            int result = new SPCreateAbrechnung(this.dbConnection, beginMonth, beginYear, endMonth, endYear).call();
            if (result == -1) {
                return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "Invalid Dates!");
            }
            AbrechnungsArr arr = new SPGetAbrechnung(this.dbConnection, result).call();
            if (arr == null) {
                return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "No Data Found!");
            }
            return res.setStatus(HTTPStatus.SUCCESS_201_CREATED).send(arr.toJSONString());

        } catch(Exception e) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, e.getMessage());
        }
    }

    /*@Override
    public ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param) {

        if (super.requiresHigherPermissions(req))
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_401_NOT_AUTHORIZED, "Not authorized");

        if (!req.getBody().containsKey("begindatum") || !req.getBody().containsKey("enddatum"))
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "One or more dates are missing!");

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
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, e.getMessage());
        }
    } */


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
        return AccountRole.BACKOFFICE;
    }
}
