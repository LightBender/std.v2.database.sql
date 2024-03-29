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
        envHandle = ODBCAllocHandle();
        ODBCSetEnvAttr(envHandle, SQL_ATTR_ODBC_VERSION, 380);
        ODBCSetEnvAttr(envHandle, 201, 3); //Enable connection polling and set the pooling mode to Driver Aware
    }

    static ~this() {
        ODBCFreeHandle(envHandle);
    }

    package ODBCHandle connectionHandle;
    private string connStr;
    public @property string connectionString() { return connStr; }

    public this(string connectionString) {
        this.connStr = connectionString;
    }

    public bool open() {
        connectionHandle = ODBCAllocHandle(SQL_HANDLE_DBC, envHandle);
        connStr = ODBCDriverConnect(connectionHandle, null, connStr, cast(ushort)SQL_DRIVER_NOPROMPT);
        return true;
    }

    public void close() {
        ODBCDisconnect(connectionHandle);
        ODBCFreeHandle(connectionHandle);
    }
}

//New a class to run the static initializers and get an ODBC environment.
unittest
{
    import std.stdio;
    SqlConnection t = new SqlConnection(string.init);
    assert(t.envHandle.isValid);
    writeln("SqlConnection successfully initialized.");
}

unittest {
	import std.stdio;
	import std.process;

	string server = environment.get("ODBCTEST_SERVER");
	string database = environment.get("ODBCTEST_DATABASE");
	string user = environment.get("ODBCTEST_USER");
	string password = environment.get("ODBCTEST_PASSWORD");

	assert (server !is null && database !is null && user !is null && password !is null);

	SqlConnection t = new SqlConnection("Driver={ODBC Driver 17 for SQL Server};Server=" ~ server ~ ";Database=" ~ database ~ ";UID=" ~ user ~ ";PWD={" ~ password ~ "};Encrypt=yes;TrustServerCertificate=yes;");
	writeln(t.connectionString);
	t.open();
	writeln("Connection successfully opened to server: " ~ server);
	t.close();
	writeln("Connection closed.");
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
