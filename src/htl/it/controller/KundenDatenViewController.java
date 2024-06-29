package htl.it.controller;

import htl.it.database.dbconnection.DBConnection;
import htl.it.database.model.AccountRole;
import http.server.implementation.common.status.HTTPStatus;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.request.HTTPRequest;
import http.server.implementation.response.ResponseBuilder;

import java.util.HashMap;

public class KundenDatenViewController extends Controller {
    public KundenDatenViewController(DBConnection dbConnection) {
        super(dbConnection);
    }

    @Override
    public ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param) {
        if (!super.hasRequiredPermissionsParam(param)) {
            return res.html("login/login.html").setStatus(HTTPStatus.REDIRECT_307_TEMP);
        }

        return res.html("kundendaten/tankkarte.html");
    }

    @Override
    public String getRoute() {
        return "/kundendaten/:sessionID";
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
