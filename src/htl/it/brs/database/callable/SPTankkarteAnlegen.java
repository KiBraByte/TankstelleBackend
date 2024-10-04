package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;

import java.math.BigDecimal;
import java.sql.*;

public class SPTankkarteAnlegen extends DBCallableStatement<Integer> {
    private final int kundenNr;
    private final String ausgestelltAuf;
    private final String pan;

    private final Date bis;

    private final BigDecimal kartenLimit;

    public SPTankkarteAnlegen(DBConnection dbConnection, int kundenNr,String pan, Date bis, BigDecimal kartenLimit) {
        super(dbConnection);
        this.kundenNr = kundenNr;
        this.ausgestelltAuf = String.format("Fahrer%04d", kundenNr);
        this.pan = pan;
        this.bis = bis;
        this.kartenLimit = kartenLimit;
    }

    @Override
    @SuppressWarnings("all")
    public Integer call() throws SQLException {
        try (CallableStatement cs = super.dbConnection.getCon().prepareCall("{? = call sp_tankkarte_erstellen(?,?,?,?,?)}")) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setInt(2, this.kundenNr);
            cs.setString(3, this.ausgestelltAuf);
            cs.setString(4, this.pan);
            cs.setDate(5, this.bis);
            cs.setBigDecimal(6, this.kartenLimit);

            cs.execute();
            return cs.getInt(1);
        }
    }
}
