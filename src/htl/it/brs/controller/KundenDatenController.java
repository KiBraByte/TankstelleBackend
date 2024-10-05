package htl.it.brs.controller;

import htl.it.brs.database.callable.SPGetKundenDaten;
import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.AccountRole;
import htl.it.brs.database.model.KundenDaten;
import http.server.implementation.common.status.HTTPStatus;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.request.HTTPRequest;
import http.server.implementation.response.ResponseBuilder;

import java.util.HashMap;

public class KundenDatenController extends Controller{

    public KundenDatenController(DBConnection dbConnection) {
        super(dbConnection);
    }

        @Override
    public ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param) {
        if (super.requiresHigherPermissions(param)) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_401_NOT_AUTHORIZED, "Not authorized");
        }

        if (!param.containsKey("sessionID")) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "No kundenNr found!");
        }

        try {
            int kundenNr = Integer.parseInt(param.get("sessionID"));
            KundenDaten kundenDaten = new SPGetKundenDaten(super.dbConnection, kundenNr).call();

            if (kundenDaten == null) {
                return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_404_NOT_FOUND, "Kunde not found!");
            } else {
                return res.send(kundenDaten.toJSONString());
            }
        } catch (Exception e) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, e.getMessage());
        }
    }

    @Override
    public String getRoute() {
        return "/api/kundendaten/:sessionID";
    }

    @Override
    public HTTPMethod getHTTPMethod() {
        return HTTPMethod.GET;
    }


    @Override
    public AccountRole getRequiredRole() {
        return AccountRole.USER;
    }
}
