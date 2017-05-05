module std.experimental.database.sql.query;

import std.datetime;
import std.typecons;
import std.variant;
import std.uuid;

import std.experimental.database.sql.connection;
import std.experimental.database.sql.reader;
import std.experimental.database.sql.table;

public enum SqlParameterDirection
{
	Input,
	InputOutput,
	Output,
	Return,
}

public struct SqlParameter
{
    public Nullable!Variant value;
    public bool nullable;
    public int length;
    public ubyte precision;
    public ubyte scale;
    public string udtName;
    public SqlParameterDirection direction;
}

public struct SqlQuery
{
    public string query;
    public int timeout;
    public SqlConnection conn;
    public SqlParameter[] params;
}

public interface SqlExecutor
{
    void queryNoResult(SqlQuery query);
    SqlReader!T queryReader(T...)(SqlQuery query);
    SqlTable!T queryTable(T...)(SqlQuery query);
}
