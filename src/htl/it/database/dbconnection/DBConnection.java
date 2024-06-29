package htl.it.database.dbconnection;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Connection;
import java.sql.DriverManager;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class DBConnection implements AutoCloseable{
    private Connection con;

    @Setter(value = AccessLevel.PRIVATE) private DBConnectionSettings settings;

    /**
     * @return return an instance of a DBCon
     * @param settings the Settings the instance is created with
     * */
    public static DBConnection createDBCon(DBConnectionSettings settings) throws Exception {
        DBConnection dbCon = new DBConnection();
        dbCon.setSettings(settings);
        dbCon.setConnection();
        return dbCon;
    }

    private String buildConString() throws Exception {
        switch (settings.getSetting(DBConnectionSettings.Conf.DRIVER).toUpperCase()) {
            case "HSQLDB":
                String formatHSQLDB = "jdbc:hsqldb:file:%s; %s";
                return String.format(formatHSQLDB,
                        settings.getSetting(DBConnectionSettings.Conf.LOCATION),
                        settings.getSetting(DBConnectionSettings.Conf.ADDITIONAL_PROPS));
            case "MYSQL":
            case "SQLSERVER":
                String formatSQL = "jdbc:%s://%s; %s";
                return String.format(formatSQL,
                        settings.getSetting(DBConnectionSettings.Conf.DRIVER),
                        settings.getSetting(DBConnectionSettings.Conf.LOCATION),
                        settings.getSetting(DBConnectionSettings.Conf.ADDITIONAL_PROPS));

            default:
                throw new Exception("Driver null or unsupported!");
        }
    }

    private void setConnection() throws Exception {
        this.con = DriverManager.getConnection(buildConString(),settings.getSetting(DBConnectionSettings.Conf.USERNAME), settings.getSetting(DBConnectionSettings.Conf.PASSWORD));
    }

    @Override
    public void close() throws Exception {
        if (this.con != null && !this.con.isClosed())  this.con.close();
    }
}
