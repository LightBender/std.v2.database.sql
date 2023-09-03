module std.v2.database.sql.connection;

import std.conv;
import std.datetime;
import std.string;
import std.typecons;
import std.variant;
import std.uuid;
import std.utf;

import std.v2.database.sql.odbc;
import std.v2.database.sql.command;
import std.v2.database.sql.reader;
import std.v2.database.sql.table;

@safe:

public class SqlConnection {
    private static ODBCHandle envHandle;

    static this() {
        envHandle = ODBCAllocHandle(SQL_HANDLE_ENV);
        ODBCSetEnvAttr(envHandle, SQL_ATTR_ODBC_VERSION, to!string(SQL_SPEC_STRING));
        //ODBCSetEnvAttr(null, SQL_CP_DRIVER_AWARE, null, null); Not supported in current ODBC bindings
    }
    
    static ~this() {
        ODBCFreeHandle(envHandle);
    }

    package ODBCHandle connectionHandle;
    private string connStr;
    public @property string connectionString() { return connStr; }

    public this(string connectionString) {
        this.connStr = connectionString;

        connectionHandle = ODBCAllocHandle(SQL_HANDLE_DBC, envHandle);
    }

    ~this() {
        ODBCFreeHandle(connectionHandle);
    }

    public bool open() {
        connStr = ODBCDriverConnect(connectionHandle, null, connStr, cast(ushort)SQL_DRIVER_NOPROMPT);
        return true;
    }

    public void close() {
        ODBCDisconnect(connectionHandle);
    }
}

//New a class to initialize the statics and get an ODBC environment.
unittest
{
    import std.stdio;
    SqlConnection t = new SqlConnection(string.init);
    assert(t.envHandle.isValid);
    writeln("SqlConnection successfully initialized.");
}

public interface ISqlConnection
{
    bool open();
    void close();

    int queryNoResult(SqlCommand query);
    ISqlReader[] queryReader(SqlCommand query);
    SqlTable[] queryTable(SqlCommand query);

    void beginTransaction();
    void commitTransaction();
    void rollBackTransaction();
}
