package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.KundenDaten;
import htl.it.brs.database.model.Tankkarte;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public final class SPGetKundenDaten extends DBCallableStatement<KundenDaten>{
    private final int sessionID;
    public SPGetKundenDaten(DBConnection dbConnection, int sessionID) {
        super(dbConnection);
        this.sessionID = sessionID;
    }

    @Override
    public KundenDaten call() throws SQLException {
        try(CallableStatement cs = dbConnection.getCon().prepareCall("{call sp_get_kunden_daten(?)}")) {
            cs.setInt(1, sessionID);

            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    KundenDaten k = new KundenDaten(rs.getString(1), rs.getBigDecimal(2), rs.getBigDecimal(3));
                    Tankkarte currT = new Tankkarte(rs.getBigDecimal(4), rs.getString(5), rs.getBigDecimal(7));
                    boolean hasNext = false;

                    while (rs.next()) {
                        String currPan;
                        String currProduct;
                        BigDecimal currLimit;
                        BigDecimal currGetankt;

                        do {
                            currPan = rs.getString(5);
                            currProduct = rs.getString(6);
                            currLimit = rs.getBigDecimal(4);
                            currGetankt = rs.getBigDecimal(7);

                            if (currT.getPan() == null || !currT.getPan().equals(currPan)) {
                                break;
                            }
                            currT.addCardProdukt(currProduct);
                            k.addProdukt(currProduct);
                            hasNext = rs.next();
                        } while(hasNext);

                        k.addTankkarte(currT);

                        if (hasNext) {
                            currT = new Tankkarte(currLimit, currPan, currGetankt);
                            currT.addCardProdukt(currProduct);
                        }
                    }

                    return k;
                }

                return null;
            }
        }
    }
}
