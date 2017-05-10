module std.experimental.database.sql.query;

import std.datetime;
import std.typecons;
import std.variant;
import std.uuid;

import std.experimental.database.sql.connection;
import std.experimental.database.sql.reader;
import std.experimental.database.sql.table;
import std.experimental.database.sql.value;

public enum SqlParameterDirection
{
	Input,
	InputOutput,
	Output,
	Return,
}

public struct SqlParameter
{
    public string name;
    public SqlValue value;
    public bool nullable;
    public int length;
    public ubyte precision;
    public ubyte scale;
    public string udtName;
    public SqlParameterDirection direction;

    public this(string name, SqlValue value)
    {
        this.name = name;
        this.value = value;
        this.nullable = true;
        this.length = 0;
        this.precision = 0;
        this.scale = 0;
        this.udtName = null;
        this.direction = SqlParameterDirection.Input;
    }
}

public struct SqlQuery
{
    public string query;
    public int timeout;
    public SqlConnection conn;
    public SqlParameter[] params;

    public this(SqlConnection conn, string query, int timeout = 0)
    {
        this.conn = conn;
        this.query = query;
        this.timeout = timeout;
    }
}

public interface SqlExecutor
{
    void queryNoResult(SqlQuery query);
    SqlReader!T queryReader(T...)(SqlQuery query);
    SqlTable!T queryTable(T...)(SqlQuery query);
}
