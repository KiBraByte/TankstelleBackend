package htl.it.database.callable;

import htl.it.database.dbconnection.DBConnection;
import htl.it.database.model.Abrechnung;

import java.sql.SQLException;

public class SPGetLetzteAbrechnungFor extends DBCallableStatement<Abrechnung>{
    public SPGetLetzteAbrechnungFor(DBConnection dbConnection) {
        super(dbConnection);
    }

    @Override
    public Abrechnung call() throws SQLException {
        return null;
    }

    @Override
    String getMSSQLName() {
        return null;
    }

}
