package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;

public class SPCreateAbrechnung extends DBCallableStatement<Integer> {
    private int beginMonth, beginYear, endMonth, endYear;

    public SPCreateAbrechnung(DBConnection dbConnection, int beginMonth, int beginYear, int endMonth, int endYear) {
        super(dbConnection);
        this.beginMonth = beginMonth;
        this.beginYear = beginYear;
        this.endMonth = endMonth;
        this.endYear = endYear;
    }

    @Override
    public Integer call() throws SQLException {
        try (CallableStatement cs = super.dbConnection.getCon().prepareCall("{? = call sp_erstelle_abrechnung(?,?,?,?)}")) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setInt(2, this.beginMonth);
            cs.setInt(3, this.beginYear);
            cs.setInt(4, this.endMonth);
            cs.setInt(5, this.endYear);

            cs.execute();
            return cs.getInt(1);
        }
    }
}
