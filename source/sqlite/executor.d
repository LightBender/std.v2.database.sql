module std.experimental.database.sql.sqlite.executor;

import d2sqlite3;
import std.typecons : Nullable;

import std.experimental.database.sql.connection;
import std.experimental.database.sql.sqlite.reader;
import std.experimental.database.sql.table;
import std.experimental.database.sql.query;

public class SqliteExecutor : SqlExecutor
{
    public void queryNoResult(SqlQuery query)
	{
		auto db = getDatabase(query.conn);
		auto statement = prepareQuery(db, query);
		statement.execute();
	}

    public SqlReader!T queryReader(T...)(SqlQuery query)
	{
		auto db = getDatabase(query.conn);
		auto statement = prepareQuery(db, query);
		return new SqliteReader!T(statement.execute());
	}

    public SqlTable!T queryTable(T...)(SqlQuery query)
	{
		auto db = getDatabase(query.conn);
		auto statement = prepareQuery(db, query);
		auto reader = new SqliteReader!T(statement.execute());
		return new SqlTable!T(reader);
	}

	private Database getDatabase(SqlConnection conn)
	{
		string connection = "Data Source=" ~ conn.hostname ~ ";Version=3;";
		return Database(connection);
	}

	private Statement prepareQuery(Database db, SqlQuery query)
	{
		Statement statement = db.prepare(query.query);
		foreach(SqlParameter param; query.params)
		{
			if (param.value.isNull())
			{
				statement.bind(param.name, "NULL");
			}
			else
			{
				statement.bind(param.name, param.value.get().toString());
			}
		}
		return statement;
	}
}
