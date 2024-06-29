package htl.it.controller;

import htl.it.database.callable.SPSessionRole;
import htl.it.database.dbconnection.DBConnection;
import htl.it.database.model.AccountRole;
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
    //registriert den Controller am Server
    public void register(Server server) {
        server.use(this.getHTTPMethod(), this.getRoute(), this::controller);
    }

    //hier muss die logik implementiert werden
    public abstract ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param);

    //Route des Controllers
    public abstract String getRoute();

    //Methode
    public abstract HTTPMethod getHTTPMethod();

    //Mindest Rolle
    public abstract AccountRole getRequiredRole();

    protected ResponseBuilder buildErrorResponse(ResponseBuilder res, HTTPStatus status, String error) {
        return res.setStatus(status).send(String.format("{\"error\": \"%s\"}", error));
    }

    protected boolean hasRequiredPermissions(HTTPRequest req) {
        try {
            int sessionID = Integer.parseInt(req.getBody().get("sessionID"));
            AccountRole accountRole = new SPSessionRole(dbConnection,sessionID).call();
            return accountRole.isAllowed(getRequiredRole());
        } catch (Exception e) {
            return getRequiredRole() == AccountRole.NONE;
        }
    }

    protected boolean hasRequiredPermissionsParam(HashMap<String, String> params) {
        try {
            int sessionID = Integer.parseInt(params.get("sessionID"));
            AccountRole accountRole = new SPSessionRole(dbConnection,sessionID).call();
            return accountRole.isAllowed(getRequiredRole());
        } catch (Exception e) {
            return getRequiredRole() == AccountRole.NONE;
        }
    }
}
