module std.experimental.database.sql.sqlite.reader;

import d2sqlite3;
import std.typecons : Nullable;

import std.experimental.database.sql.row;
import std.experimental.database.sql.reader;
import std.experimental.database.sql.value;

import std.stdio;

public class SqliteReader : SqlReader
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

		return !resultSet.empty;
	}

	public SqlValue getField(int fieldOrdinal)
	{
		ColumnData cd = currentRow[fieldOrdinal];
		switch(cd.type)
		{
			case SqliteType.NULL:
				return SqlValue.SqlNull();
			case SqliteType.BLOB:
				return SqlValue.SqlUByteArray(cd.as!(ubyte[])());
			case SqliteType.FLOAT:
				return SqlValue.SqlFloat(cd.as!float());
			case SqliteType.INTEGER:
				return SqlValue.SqlLong(cd.as!long());
			case SqliteType.TEXT:
				return SqlValue.SqlString(cd.as!string());
			default:
				return SqlValue.SqlNull();
		}
	}

	public SqlRow getRow()
	{
		auto sqlRow = new SqlRow(currentRow.length);
		int c = 0;
		foreach(ColumnData cd; currentRow)
		{
			switch(cd.type)
			{
				case SqliteType.NULL:
					sqlRow.setField(c++, SqlValue.SqlNull());
					break;
				case SqliteType.BLOB:
					sqlRow.setField(c++, SqlValue.SqlUByteArray(cd.as!(ubyte[])()));
					break;
				case SqliteType.FLOAT:
					sqlRow.setField(c++, SqlValue.SqlFloat(cd.as!float()));
					break;
				case SqliteType.INTEGER:
					sqlRow.setField(c++, SqlValue.SqlLong(cd.as!long()));
					break;
				case SqliteType.TEXT:
					sqlRow.setField(c++, SqlValue.SqlString(cd.as!string()));
					break;
				default: break;
			}
		}

		return sqlRow;
	}
}
