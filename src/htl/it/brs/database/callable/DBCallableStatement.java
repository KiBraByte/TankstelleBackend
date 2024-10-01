package htl.it.brs.database.callable;

import htl.it.brs.database.dbconnection.DBConnection;

import java.sql.SQLException;

//Callable Statements wie Stored Procedures oder Functions
public abstract class DBCallableStatement<T> {

    protected final DBConnection dbConnection;

    public DBCallableStatement(DBConnection dbConnection) {
        this.dbConnection = dbConnection;
    }

    public abstract T call() throws SQLException;
}
