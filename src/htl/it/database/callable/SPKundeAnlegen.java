package htl.it.database.callable;

import htl.it.database.dbconnection.DBConnection;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

public class SPKundeAnlegen extends DBCallableStatement<Integer> {

    private final String firmenName;
    private final boolean status;
    private final BigDecimal limit;
    public SPKundeAnlegen(DBConnection dbConnection, String firmenName, boolean status, BigDecimal limit) {
        super(dbConnection);

        this.firmenName = firmenName;
        this.status = status;
        this.limit = limit;
    }

    @Override
    @SuppressWarnings("all")
    public Integer call() throws SQLException {
        try(CallableStatement cs = dbConnection.getCon().prepareCall(String.format("{? = call %s(?,?,?)}", getMSSQLName()))) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setString(2, this.firmenName);
            cs.setBoolean(3, this.status);
            cs.setBigDecimal(4, this.limit);

            cs.execute();
            return cs.getObject(1, Integer.class);
        }
    }

    @Override
    String getMSSQLName() {
        return "sp_kunde_erstellen";
    }
}
