package htl.it.brs.controller;

import htl.it.brs.database.callable.SPSessionRole;
import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.AccountRole;
import http.server.implementation.common.status.HTTPStatus;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.request.HTTPRequest;
import http.server.implementation.response.ResponseBuilder;
import http.server.implementation.server.Server;

import java.util.HashMap;

//Controller
public abstract class Controller {
    protected DBConnection dbConnection;

    public Controller(DBConnection dbConnection) {
        this.dbConnection = dbConnection;
    }
    public abstract ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param);

    public abstract String getRoute();

    public abstract HTTPMethod getHTTPMethod();

    public abstract AccountRole getRequiredRole();

    //******************************************************************************************************************
    // HELPER METHODS
    //******************************************************************************************************************

    public void register(Server server) {
        server.use(this.getHTTPMethod(), this.getRoute(), this::controller);
    }

    protected ResponseBuilder buildErrorResponse(ResponseBuilder res, HTTPStatus status, String error) {
        return res.setStatus(status).send(String.format("{\"error\": \"%s\"}", error));
    }

    protected boolean requiresHigherPermissions(String sessionString) {
        try {
            int sessionID = Integer.parseInt(sessionString);
            AccountRole accountRole = new SPSessionRole(dbConnection,sessionID).call();
            return !accountRole.isAllowed(getRequiredRole());
        } catch (Exception e) {
            return getRequiredRole() != AccountRole.NONE;
        }
    }

    protected boolean requiresHigherPermissions(HTTPRequest req) {
        return this.requiresHigherPermissions(req.getBody().get("sessionID"));
    }

    protected boolean requiresHigherPermissions(HashMap<String, String> params) {
        return this.requiresHigherPermissions(params.get("sessionID"));
    }

    protected boolean containsAndNotEmpty(HTTPRequest req, String key) {
        return req.getBody().containsKey(key) && !req.getBody().get(key).isEmpty();
    }
}
