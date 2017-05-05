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
    Nullable!Variant value;
    bool nullable;
    int length;
    ubyte precision;
    ubyte scale;
    string udtName;
    SqlParameterDirection direction;
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
    void QueryNoResult(SqlQuery query);
    SqlReader QueryReader(SqlQuery query);
    SqlTableBase QueryTable(SqlQuery query);
}
