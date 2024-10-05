package htl.it.brs.controller;

import htl.it.brs.database.callable.SPGetTankkartenDaten;
import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.AccountRole;
import htl.it.brs.database.model.Tankkarte;
import http.server.implementation.common.status.HTTPStatus;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.request.HTTPRequest;
import http.server.implementation.response.ResponseBuilder;

import java.util.HashMap;

public class TankkartenDatenController extends Controller{

    public TankkartenDatenController(DBConnection dbConnection) {
        super(dbConnection);
    }

    @Override
    public ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param) {
        if (super.requiresHigherPermissions(param)) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_401_NOT_AUTHORIZED, "Not authorized");
        }

        if (!param.containsKey("pan")) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "No PAN found!");
        }

        try {
            String pan = param.get("pan");
            Tankkarte t = new SPGetTankkartenDaten(super.dbConnection, pan).call();

            if (t == null) {
                return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_404_NOT_FOUND, "Tankkarte not found!");
            } else {
                return res.send(t.toJSONString());
            }
        } catch (Exception e) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, e.getMessage());
        }
    }

    @Override
    public String getRoute() {
        return "/api/tankkartendaten/:pan";
    }

    @Override
    public HTTPMethod getHTTPMethod() {
        return HTTPMethod.GET;
    }


    @Override
    public AccountRole getRequiredRole() {
        return AccountRole.NONE;
    }
}
