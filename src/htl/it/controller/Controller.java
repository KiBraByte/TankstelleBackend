package htl.it.controller;

import htl.it.database.dbconnection.DBConnection;
import http.server.implementation.common.status.HTTPStatus;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.request.HTTPRequest;
import http.server.implementation.response.ResponseBuilder;
import http.server.implementation.response.ResponseDirector;
import http.server.implementation.server.Server;

import java.util.HashMap;

public abstract class Controller {
    protected DBConnection dbConnection;


    public Controller(DBConnection dbConnection) {
        this.dbConnection = dbConnection;
    }
    public void register(Server server) {
        server.use(this.getHTTPMethod(), this.getRoute(), this::controller);
    }

    public abstract ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param);

    public abstract String getRoute();

    public abstract HTTPMethod getHTTPMethod();

    protected ResponseBuilder buildErrorResponse(ResponseBuilder res, HTTPStatus status, String error) {
        return res.setStatus(status).send(String.format("{\"error\": \"%s\"}", error));
    }
}
