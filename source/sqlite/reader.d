module std.experimental.database.sql.sqlite.reader;

import d2sqlite3;
import std.typecons : Nullable;

import std.experimental.database.sql.reader;

public class SqliteReader(T...) : SqlReader!T
{
	public @property bool hasRows()
	{
		return false;
	}

	public bool next()
	{
		return false;
	}

	Nullable!T getField(T)(int fieldOrdinal)
	{
		return Nullable!T;
	}

	SqlRow!T getRow()
	{
		return null;
	}
}
