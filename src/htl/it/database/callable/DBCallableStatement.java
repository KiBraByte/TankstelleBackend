package htl.it.database.callable;

import htl.it.database.dbconnection.DBConnection;

import java.sql.SQLException;

public abstract class DBCallableStatement<T> {

    protected final DBConnection dbConnection;

    public DBCallableStatement(DBConnection dbConnection) {
        this.dbConnection = dbConnection;
    }

    public abstract T call() throws SQLException;

    abstract String getMSSQLName();
}
