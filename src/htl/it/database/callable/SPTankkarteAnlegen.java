package htl.it.database.callable;

import htl.it.database.dbconnection.DBConnection;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Types;

public class SPTankkarteAnlegen extends DBCallableStatement<Integer> {
    private final int kundenNr;
    private final String pan;

    private final Date bis;

    private final BigDecimal kartenLimit;

    public SPTankkarteAnlegen(DBConnection dbConnection, int kundenNr, String pan, Date bis, BigDecimal kartenLimit) {
        super(dbConnection);
        this.kundenNr = kundenNr;
        this.pan = pan;
        this.bis = bis;
        this.kartenLimit = kartenLimit;
    }

    @Override
    @SuppressWarnings("all")
    public Integer call() throws SQLException {
        try (CallableStatement cs = super.dbConnection.getCon().prepareCall(String.format("{call %s(?,?,?,?)}", this.getMSSQLName()))) {
            cs.setInt(1, this.kundenNr);
            cs.setString(2, this.pan);
            cs.setDate(3, this.bis);
            cs.setBigDecimal(4, this.kartenLimit);

            cs.execute();
            return 0;
        }
    }

    @Override
    String getMSSQLName() {
        return "sp_tankkarte_erstellen";
    }
}
