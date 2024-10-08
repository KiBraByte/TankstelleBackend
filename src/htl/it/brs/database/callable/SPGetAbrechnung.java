package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.AbrechnungsArr;
import htl.it.brs.database.model.AbrechnungsModel;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SPGetAbrechnung extends DBCallableStatement<AbrechnungsArr> {

    private final int abNr;

    public SPGetAbrechnung(DBConnection dbConnection, int abNr) {
        super(dbConnection);
        this.abNr = abNr;
    }

    @Override
    public AbrechnungsArr call() throws SQLException {
        try (CallableStatement cs = super.dbConnection.getCon().prepareCall("{call sp_get_abrechnungsdaten(?)}")) {
            cs.setInt(1, this.abNr);

            try(ResultSet rs =  cs.executeQuery()) {

                if (rs.next()) {
                    AbrechnungsArr k = new AbrechnungsArr();
                    AbrechnungsModel a = new AbrechnungsModel(rs.getInt(1), rs.getString(2), rs.getBigDecimal(3));
                    boolean hasNext = false;

                    while (rs.next()) {
                        int currKNr;

                        do {
                            currKNr = rs.getInt(1);

                            if (!(a.getKundenNr() == currKNr)) {
                                break;
                            }

                            hasNext = rs.next();
                        } while (hasNext);

                        if (a.getKundenPrice().intValue() != 0) {
                            k.addAbrechnung(a);
                        }

                        if (hasNext) {
                            a = new AbrechnungsModel(currKNr, rs.getString(2), rs.getBigDecimal(3));
                        }
                    }
                    return k;
                }
            }
        }
        return null;
    }
}
