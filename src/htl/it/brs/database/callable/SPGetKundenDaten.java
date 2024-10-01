package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.KundenDaten;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public final class SPGetKundenDaten extends DBCallableStatement<KundenDaten>{
    private final int KNr;
    public SPGetKundenDaten(DBConnection dbConnection, int KNr) {
        super(dbConnection);
        this.KNr = KNr;
    }

    @Override
    public KundenDaten call() throws SQLException {
        try(CallableStatement cs = dbConnection.getCon().prepareCall("{call sp_get_kunden_daten(?)}")) {
            cs.setInt(1, KNr);

            try (ResultSet rs = cs.executeQuery()) {

                if (rs.next()) {
                    KundenDaten k = new KundenDaten(rs.getString(1), rs.getBigDecimal(2), rs.getBigDecimal(3));

                    do {
                        if (rs.getString(4) != null) {
                            k.addProdukt(rs.getString(4));
                        }
                    } while(rs.next());

                    return k;
                } else return null;
            }
        }
    }
}
