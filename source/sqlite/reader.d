module std.experimental.database.sql.sqlite.reader;

import d2sqlite3;
import std.typecons : Nullable;

import std.experimental.database.sql.reader;

public class SqliteReader(T...) : SqlReader!T
{
	private immutable ResultRange resultSet;
	private bool firstRowProcessed = false;
	private Row currentRow;

	package this(ResultRange resultSet)
	{
		this.resultSet = cast(immutable)resultSet;
	}

	public @property bool hasRows()
	{
		return this.resultSet.empty;
	}

	public bool next()
	{
		if (firstRowProcessed)
		{
			resultSet.popFront();
		}
		else
		{
			firstRowProcessed = true;
		}

		if (!resultSet.empty)
		{
			currentRow = resultSet.front();
		}

		return resultSet.empty;
	}

	public Nullable!T getField(T)(int fieldOrdinal)
	{
		return Nullable!T(currentRow[fieldOrdinal].as!T());
	}

	public SqlRow!T getRow()
	{
		auto sqlRow = new SqlRow!T();
		int typeIdx = 0;
		foreach(ColumnData cd; currentRow)
		{
			sqlRow.setField!T[typeIdx](cd.as!T[typeIdx]());
			typeIdx++;
		}

		return sqlRow;
	}
}
