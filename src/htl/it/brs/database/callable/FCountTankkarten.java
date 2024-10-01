package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

public class FCountTankkarten extends DBCallableStatement<Integer> {

    private final int kundenNr;

    public FCountTankkarten(DBConnection dbConnection, int kundenNr) {
        super(dbConnection);
        this.kundenNr = kundenNr;
    }

    @Override
    public Integer call() throws SQLException {
        try(CallableStatement cs = dbConnection.getCon().prepareCall("{? = call f_count_tankkarten(?)}")) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setInt(2, this.kundenNr);
            cs.execute();

            return cs.getInt(1);
        }
    }
}
