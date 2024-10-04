package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

public class SPTankungAnlegen extends DBCallableStatement<Integer> {
    private final String pan;
    private final int tsnr;
    private final BigDecimal menge;

    private final BigDecimal preisProEinheit;

    private final String produkt;

    public SPTankungAnlegen(DBConnection dbConnection, String pan, int tsnr, String produkt, BigDecimal menge, BigDecimal preisProEinheit) {
        super(dbConnection);
        this.pan = pan;
        this.tsnr = tsnr;
        this.produkt = produkt;
        this.menge = menge;
        this.preisProEinheit = preisProEinheit;
    }

    @Override
    public Integer call() throws SQLException {
        try (CallableStatement cs = super.dbConnection.getCon().prepareCall("{? = call sp_tankung_erstellen(?,?,?,?,?)}")) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setString(2, this.pan);
            cs.setInt(3, this.tsnr);
            cs.setString(4, this.produkt);
            cs.setBigDecimal(5, this.menge);
            cs.setBigDecimal(6, this.preisProEinheit);

            cs.execute();

            return cs.getInt(1);
        }
    }
}
