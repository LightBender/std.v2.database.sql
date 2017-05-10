module std.experimental.database.sql.sqlite.executor;

import d2sqlite3;
import std.datetime;
import std.typecons : Nullable;
import std.variant : Variant;
import std.uuid;

import std.experimental.database.sql.connection;
import std.experimental.database.sql.sqlite.reader;
import std.experimental.database.sql.table;
import std.experimental.database.sql.query;
import std.experimental.database.sql.value;

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
		string connection = conn.hostname;
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
				switch(param.value.type)
				{
					case SqlValue.SqlType.String:
						statement.bind(param.name, param.value.get!string());
						break;
					case SqlValue.SqlType.WString:
						statement.bind(param.name, param.value.get!wstring());
						break;
					case SqlValue.SqlType.DString:
						statement.bind(param.name, param.value.get!dstring());
						break;
					case SqlValue.SqlType.Char:
						statement.bind(param.name, param.value.get!char());
						break;
					case SqlValue.SqlType.WChar:
						statement.bind(param.name, param.value.get!wchar());
						break;
					case SqlValue.SqlType.DChar:
						statement.bind(param.name, param.value.get!dchar());
						break;
					case SqlValue.SqlType.Bool:
						statement.bind(param.name, param.value.get!bool());
						break;
					case SqlValue.SqlType.Byte:
						statement.bind(param.name, param.value.get!byte());
						break;
					case SqlValue.SqlType.UByte:
						statement.bind(param.name, param.value.get!ubyte());
						break;
					case SqlValue.SqlType.UByteArray:
						statement.bind(param.name, param.value.get!(ubyte[])());
						break;
					case SqlValue.SqlType.Short:
						statement.bind(param.name, param.value.get!short());
						break;
					case SqlValue.SqlType.UShort:
						statement.bind(param.name, param.value.get!ushort());
						break;
					case SqlValue.SqlType.Int:
						statement.bind(param.name, param.value.get!int());
						break;
					case SqlValue.SqlType.UInt:
						statement.bind(param.name, param.value.get!uint());
						break;
					case SqlValue.SqlType.Long:
						statement.bind(param.name, param.value.get!long());
						break;
					case SqlValue.SqlType.ULong:
						statement.bind(param.name, param.value.get!ulong());
						break;
					case SqlValue.SqlType.Float:
						statement.bind(param.name, param.value.get!float());
						break;
					case SqlValue.SqlType.Double:
						statement.bind(param.name, param.value.get!double());
						break;
					case SqlValue.SqlType.Real:
						statement.bind(param.name, param.value.get!real());
						break;
					case SqlValue.SqlType.Uuid:
						statement.bind(param.name, param.value.get!UUID().data);
						break;
					//TODO: Research the correct way to pass std.datetime types.
					default: break;
				}
			}
		}
		return statement;
	}
}

unittest
{
	SqlConnection conn = SqlConnection(":memory:");
	auto executor = new SqliteExecutor();

	//Create the table
	SqlQuery query = SqlQuery(conn, "DROP TABLE IF EXISTS person;
        CREATE TABLE person (
          id    INTEGER PRIMARY KEY,
          name  TEXT NOT NULL,
          score FLOAT
        )");
	executor.queryNoResult(query);

	//Insert some data into the table
	SqlQuery insert = SqlQuery(conn, "INSERT INTO person (name, score) VALUES (:name, :score)");
	insert.params ~= SqlParameter(":name", SqlValue.SqlString("Adam Wilson"));
	insert.params ~= SqlParameter(":score", SqlValue.SqlFloat(10.0f));
	executor.queryNoResult(query);

	//Extract the inserted data into a SqlTable
	//SqlQuery extrat = SqlQuery(conn, "SELECT name, score FROM person");
	//auto table = executor.queryTable!(string, float)(query);
}
