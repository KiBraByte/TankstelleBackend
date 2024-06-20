import htl.it.controller.*;
import htl.it.database.dbconnection.DBConnection;
import htl.it.database.dbconnection.DBConnectionSettings;
import http.server.implementation.config.ConfigurationManager;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.server.Server;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


public class Main {
    public static void main(String[] args) throws Exception {
        ConfigurationManager.getInstance().setFilePath("res/");
        ConfigurationManager.getInstance().setPort(2000);
        ConfigurationManager.getInstance().setServeNonRegisteredRoutes(true);

        Server server = new Server();

        DBConnectionSettings settings = DBConnectionSettings.createSettings("conf/mssql_settings.cfg");
        DBConnection dbConnection = DBConnection.createDBCon(settings);

        new KundenDatenController(dbConnection).register(server);
        new KundenAnlegenController(dbConnection).register(server);
        new TankkartenAnlegenController(dbConnection).register(server);
        new TankungsController(dbConnection).register(server);
        new AbrechnungsController(dbConnection).register(server);

        server.use(HTTPMethod.GET, "/kundendaten", (req,res,params) -> res.html("kundendaten/tankkarte.html"));
        server.use(HTTPMethod.GET, "/",(req,res,params) -> res.html("main/index.html"));
        server.use(HTTPMethod.GET, "/backoffice",(req,res,params) -> res.html("backoffice/backoffice.html"));
        server.use(HTTPMethod.GET, "/kassensystem",(req,res,params) -> res.html("Kassensystem/generieren.html"));
        server.use(HTTPMethod.POST, "/kassensystem/zahlen", (req, res, params) -> {
            String[] fiels = new String[] {"produkt", "kosten", "liter"};
            List<String> list = new ArrayList<>();
            for (String key : fiels) {
                list.add(req.getBody().get(key));
            }

            System.out.println(list);

            return res.render("kassensystem/zahlen.html", list);
        });

        server.listen();

    }
}
