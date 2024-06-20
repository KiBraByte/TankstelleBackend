package htl.it.controller;

import htl.it.database.callable.SPGetKundenDaten;
import htl.it.database.dbconnection.DBConnection;
import htl.it.database.model.KundenDaten;
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
        if (!param.containsKey("kundenNr")) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "No kundenNr found!");
        }

        try {
            int kundenNr = Integer.parseInt(param.get("kundenNr"));
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
        return "/api/kundendaten/:kundenNr";
    }

    @Override
    public HTTPMethod getHTTPMethod() {
        return HTTPMethod.GET;
    }
}
