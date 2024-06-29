package htl.it.database.callable;

import htl.it.database.dbconnection.DBConnection;

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
    @SuppressWarnings("all")
    public Integer call() throws SQLException {
        try (CallableStatement cs = super.dbConnection.getCon().prepareCall(String.format("{? = call %s(?,?,?)}", this.getMSSQLName()))) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setString(2, this.userName);
            cs.setString(3, passwordHash);
            cs.setInt(4, this.kundenNr);

            cs.execute();

            return cs.getInt(1);
        }
    }

    @Override
    String getMSSQLName() {
        return "sp_create_user_account";
    }
}
