package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Types;

public class SPBerechneAbrechnung extends DBCallableStatement<Integer> {

    private final Date beginDate;

    private final Date endDate;

    public SPBerechneAbrechnung(DBConnection dbConnection, Date beginDate, Date endDate) {
        super(dbConnection);
        this.beginDate = beginDate;
        this.endDate = endDate;
    }

    @Override
    public Integer call() throws SQLException {
        try(CallableStatement cs = super.dbConnection.getCon().prepareCall("{? = call sp_berechne_abrechnung(?,?)}")) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setDate(2, this.beginDate);
            cs.setDate(3, this.endDate);

            cs.execute();

            return cs.getObject(1, Integer.class);
        }
    }
}
