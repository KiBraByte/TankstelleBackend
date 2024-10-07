package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.Tankkarte;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SPGetTankkartenDaten extends DBCallableStatement<Tankkarte> {

    private final String pan;
    public SPGetTankkartenDaten(DBConnection dbConnection, String pan) {
        super(dbConnection);
        this.pan = pan;
    }

    @Override
    public Tankkarte call() throws SQLException {
        try(CallableStatement cs = super.dbConnection.getCon().prepareCall("{call sp_get_tankkarten_daten(?)}")) {
            cs.setString(1, this.pan);

            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next())  {
                    Tankkarte t = new Tankkarte(rs.getBigDecimal(1) , rs.getString(2), rs.getBigDecimal(4));
                    do {
                        t.addCardProdukt(rs.getString(3));
                    } while(rs.next());
                    return t;
                }
                return null;
            }
        }
    }
}
