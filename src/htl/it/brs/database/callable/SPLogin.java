package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.LoginDaten;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

public class SPLogin extends DBCallableStatement<LoginDaten>{
    private final String userName;
    private final String passwordHash;

    public SPLogin(DBConnection dbConnection, String userName, String passwordHash) {
        super(dbConnection);
        this.userName = userName;
        this.passwordHash = passwordHash;
    }

    @Override
    public LoginDaten call() throws SQLException {
        try (CallableStatement cs = super.dbConnection.getCon().prepareCall("{? = call sp_login(?,?)}")) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setString(2, this.userName);
            cs.setString(3, this.passwordHash);

            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    return new LoginDaten(rs.getInt(1), rs.getInt(2));
                }
            }

            return null;
        }
    }
}
