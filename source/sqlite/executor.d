module std.experimental.database.sql.sqlite.executor;

import d2sqlite3;
import std.typecons : Nullable;

import std.experimental.database.sql.query;

public class SqliteExecutor : SqlExecutor
{
    void queryNoResult(SqlQuery query)
	{
	}

    SqlReader!T queryReader(T...)(SqlQuery query)
	{
		return null;
	}

    SqlTable!T queryTable(T...)(SqlQuery query)
	{
		return null;
	}
}
