package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.AccountRole;

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
    public AccountRole call() throws SQLException {
        try(CallableStatement cs = super.dbConnection.getCon().prepareCall("{? = call sp_session_role(?)}")) {
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
}
