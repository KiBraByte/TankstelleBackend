package htl.it.database.callable;

import htl.it.database.dbconnection.DBConnection;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

public final class FGetProduktByName extends DBCallableStatement<Short>  {

    private final String produktName;

    public FGetProduktByName(DBConnection dbConnection, String produktName) {
        super(dbConnection);
        this.produktName = produktName;
    }

    @Override
    @SuppressWarnings("all")
    public Short call() throws SQLException {
         try(CallableStatement cs = dbConnection.getCon().prepareCall(String.format("{? = call %s(?)}", getMSSQLName()))) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setString(2, this.produktName);
            cs.execute();
            return cs.getShort(1);
         }
    }

    @Override
    String getMSSQLName() {
        return "f_get_produkt_by_name";
    }
}
