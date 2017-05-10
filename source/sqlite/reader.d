module std.experimental.database.sql.sqlite.reader;

import d2sqlite3;
import std.typecons : Nullable;

import std.experimental.database.sql.row;
import std.experimental.database.sql.reader;
import std.experimental.database.sql.value;

public class SqliteReader(T...) : SqlReader!T
{
	private ResultRange resultSet;
	private bool firstRowProcessed = false;
	private Row currentRow;

	package this(ResultRange resultSet)
	{
		this.resultSet = resultSet;
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

	public SqlValue getField(int fieldOrdinal)
	{
		return SqlValue.SqlString(currentRow[fieldOrdinal].as!string());
	}

	public SqlRow!T getRow()
	{
		auto sqlRow = new SqlRow!T();
		int typeIdx = 0;
		foreach(ColumnData cd; currentRow)
		{
			//sqlRow.setField!T[typeIdx](cd.as!T[typeIdx]());
			typeIdx++;
		}

		return sqlRow;
	}
}
