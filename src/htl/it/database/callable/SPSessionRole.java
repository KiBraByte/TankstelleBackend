package htl.it.database.callable;

import htl.it.database.dbconnection.DBConnection;
import htl.it.database.model.AccountRole;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

public class SPSessionRole extends DBCallableStatement<AccountRole> {
    private final int sessionID;

    public SPSessionRole(DBConnection dbConnection, int sessionID) {
        super(dbConnection);
        this.sessionID = sessionID;
    }

    @Override
    @SuppressWarnings("all")
    public AccountRole call() throws SQLException {
        try(CallableStatement cs = super.dbConnection.getCon().prepareCall(String.format("{? = call %s(?)}", this.getMSSQLName()))) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setInt(2, this.sessionID);

            cs.execute();
            int idx = cs.getInt(1);
            if (idx == -1 || idx > AccountRole.values().length - 1) {
                return AccountRole.NONE;
            }
            System.out.println(idx);
            return AccountRole.values()[idx - 1];
        }
    }

    @Override
    String getMSSQLName() {
        return "sp_session_role";
    }
}
