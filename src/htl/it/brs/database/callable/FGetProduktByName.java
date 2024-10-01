package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;

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
    public Short call() throws SQLException {
         try(CallableStatement cs = dbConnection.getCon().prepareCall("{? = call f_get_produkt_by_name(?)}")) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setString(2, this.produktName);
            cs.execute();
            return cs.getShort(1);
         }
    }

}
