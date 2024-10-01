package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

public class SPCreateUserAccount extends DBCallableStatement<Integer> {

    private final String userName;
    private final String passwordHash;

    private final int kundenNr;

    public SPCreateUserAccount(DBConnection dbConnection, String userName, String passwordHash, int kundenNr) {
        super(dbConnection);
        this.userName = userName;
        this.passwordHash = passwordHash;
        this.kundenNr = kundenNr;
    }

    @Override
    public Integer call() throws SQLException {
        try (CallableStatement cs = super.dbConnection.getCon().prepareCall("{? = call sp_create_user_account(?,?,?)}")) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setString(2, this.userName);
            cs.setString(3, passwordHash);
            cs.setInt(4, this.kundenNr);

            cs.execute();

            return cs.getInt(1);
        }
    }
}
