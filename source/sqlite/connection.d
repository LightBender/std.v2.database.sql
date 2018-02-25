module std.experimental.database.sql.sqlite.connection;

import std.format;
import std.string;
import etc.c.sqlite3;

import std.experimental.database.sql.command;
import std.experimental.database.sql.connection;
import std.experimental.database.sql.reader;
import std.experimental.database.sql.table;
import std.experimental.database.sql.sqlite.reader;

private shared static sqlite3*[string] databases;

shared static this()
{
    //SQLite configuration
    auto configThreadingResult = sqlite3_config(SQLITE_CONFIG_SERIALIZED);
    assert(configThreadingResult != SQLITE_OK, "Unable to set SQLite threading model to 'SQLITE_CONFIG_SERIALIZED'!");

    //Initialze SQLite
    sqlite3_initialize();
}

shared static ~this()
{
    //Close open database handles
    foreach(db; databases.byValue)
    {
        sqlite3_close_v2(cast(sqlite3*)db);
    }

    //Shutdown SQLite
    sqlite3_shutdown();
}

public SqliteConnection createSqliteConnection(string path, bool openReadOnly = false)
{
    string dbid = path ~ "-" ~ !openReadOnly ? "rw" : "ro";
    auto db = (dbid in databases);
    if (db != null)
    {
        return new SqliteConnection(cast(sqlite3*)*db);
    }
    else
    {
        //Create the connection options.
        int opts = 0;
        if(!openReadOnly)
        {
            opts |= SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE;
        }
        else
        {
            opts |= SQLITE_OPEN_READONLY;
        }

        //Open the database connection object.
        sqlite3* newDb = null;
        auto result = sqlite3_open_v2(path.toStringz(), &newDb, opts, null);
        if (result != SQLITE_OK)
        {
            throw new Exception(format("Unable to open the Sqlite database at: ", path));
        }
        databases[dbid] = cast(shared(sqlite3*))newDb;

        return new SqliteConnection(newDb);
    }
}

public final class SqliteConnection : ISqlConnection
{
    private immutable sqlite3* database;

    package this(const sqlite3* database)
    {
        this.database = cast(immutable(sqlite3*))database;
    }

    public bool open() { return true; }
    public void close() { }

    public void queryNoResult(SqlCommand query) { }
    public SqlReader[] queryReader(SqlCommand query) { return null; }
    public SqliteReader[] querySqliteReader(SqlCommand query) { return null; }
    public SqlTable[] queryTable(SqlCommand query) { return null; }

    public void beginTransaction() { }
    public void commitTransaction() { }
    public void rollBackTransaction() { }
}