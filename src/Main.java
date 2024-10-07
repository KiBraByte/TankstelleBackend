//Erstellt: 20.06.2024, Von: Kilian Brandstoetter, Beschreibung: Tankstellen Backend
import htl.it.brs.controller.*;
import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.dbconnection.DBConnectionSettings;
import http.server.implementation.config.ConfigurationManager;
import http.server.implementation.server.Server;


public class Main {
    public static void main(String[] args) throws Exception {
        ConfigurationManager.getInstance().setFilePath("res/");
        ConfigurationManager.getInstance().setPort(2000);
        ConfigurationManager.getInstance().setServeNonRegisteredRoutes(false);

        Server server = new Server();

        DBConnectionSettings settings = DBConnectionSettings.createSettings("conf/mssql_settings.cfg");
        DBConnection dbConnection = DBConnection.createDBCon(settings);

        new KundenDatenController(dbConnection).register(server);
        new KundenAnlegenController(dbConnection).register(server);
        new TankkartenAnlegenController(dbConnection).register(server);
        new TankungsController(dbConnection).register(server);
        new AbrechnungsController(dbConnection).register(server);
        new LoginController(dbConnection).register(server);
        new TankkartenDatenController(dbConnection).register(server);

        server.listen();
    }
}
