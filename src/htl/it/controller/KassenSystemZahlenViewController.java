package htl.it.controller;

import htl.it.database.dbconnection.DBConnection;
import htl.it.database.model.AccountRole;
import http.server.implementation.common.status.HTTPStatus;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.request.HTTPRequest;
import http.server.implementation.response.ResponseBuilder;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

public class KassenSystemZahlenViewController extends Controller{
    public KassenSystemZahlenViewController(DBConnection dbConnection) {
        super(dbConnection);
    }

    @Override
    public ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> params) {
        if (!super.hasRequiredPermissionsParam(params)) {
            return res.html("login/login.html").setStatus(HTTPStatus.REDIRECT_307_TEMP);
        }

        List<String> list = Arrays.asList(params.get("produkt"),params.get("kosten"),params.get("menge"));
        return res.render("kassensystem/zahlen.html", list);
    }

    @Override
    public String getRoute() {
        return "/kassensystem/zahlen/:sessionID/:produkt/:kosten/:menge";
    }

    @Override
    public HTTPMethod getHTTPMethod() {
        return HTTPMethod.GET;
    }

    @Override
    public AccountRole getRequiredRole() {
        return AccountRole.BACKOFFICE;
    }
}
