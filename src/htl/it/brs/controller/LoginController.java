package htl.it.brs.controller;

import htl.it.brs.database.callable.SPLogin;
import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.AccountRole;
import htl.it.brs.database.model.LoginDaten;
import http.server.implementation.common.status.HTTPStatus;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.request.HTTPRequest;
import http.server.implementation.response.ResponseBuilder;

import java.sql.SQLException;
import java.util.HashMap;

public class LoginController extends Controller {
    public LoginController(DBConnection dbConnection) {
        super(dbConnection);
    }

    @Override
    public ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param) {
        if (super.requiresHigherPermissions(req)) {
            return super.buildErrorResponse(res, HTTPStatus.REDIRECT_302_TEMP, "Not authorized");
        }

        if (!req.getBody().containsKey("userName") || !req.getBody().containsKey("password")) {
            super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "Password or Username not found!");
        }

        try {
            String userName = req.getBody().get("userName");
            String password = req.getBody().get("password");

            LoginDaten ld = new SPLogin(dbConnection, userName, password).call();
            if (ld.getSessionID() == -1) {
                return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "Incorrect credentials!");
            } else {
                return res.setStatus(HTTPStatus.SUCCESS_200_OK).send(ld.toJSONString());
            }
        } catch (SQLException e) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_404_NOT_FOUND, e.getMessage());
        }
    }

    @Override
    public String getRoute() {
        return "/auth/login";
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
