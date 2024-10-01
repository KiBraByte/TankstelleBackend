package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

public class SPLogin extends DBCallableStatement<Integer>{
    private final String userName;
    private final String passwordHash;

    public SPLogin(DBConnection dbConnection, String userName, String passwordHash) {
        super(dbConnection);
        this.userName = userName;
        this.passwordHash = passwordHash;
    }

    @Override
    public Integer call() throws SQLException {
        try (CallableStatement cs = super.dbConnection.getCon().prepareCall("{? = call sp_login(?,?)}")) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setString(2, this.userName);
            cs.setString(3, this.passwordHash);

            cs.execute();
            return cs.getInt(1);
        }
    }
}
