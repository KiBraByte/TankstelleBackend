package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;


public class SPProduktTankkarteZuordnen extends DBCallableStatement<Integer> {

    private final String pan;

    private final String produkt;

    public SPProduktTankkarteZuordnen(DBConnection dbConnection, String pan, String produkt) {
        super(dbConnection);
        this.pan = pan;
        this.produkt = produkt;
    }


    @Override
    public Integer call() throws SQLException {
        try (CallableStatement cs = super.dbConnection.getCon().prepareCall("{? = call sp_produkt_tankkarte_zuordnen(?,?)}")) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setString(2, this.pan);
            cs.setString(3, this.produkt);

            cs.execute();
            return cs.getInt(1);
        }
    }
}
