module std.experimental.database.sql.table;

import std.array;
import std.datetime;
import std.meta;
import std.typecons;
import std.variant;
import std.uuid;

import std.experimental.database.sql.reader;
import std.experimental.database.sql.row;
import std.experimental.database.sql.value;

import std.stdio;

public final class SqlTable
{
	protected SqlRow[] rows;

	public SqlValue getField(uint row, uint column)
	{
		return rows[row].getField(column);
	}

	public void setField(uint row, uint column, SqlValue value)
	{
		rows[row].setField(column, value);
	}

	public this(uint reserveColumns, uint reserveRows)
	{
		rows = new SqlRow[](reserveRows);
		for(int i = 0; i < reserveRows; i++)
		{
			rows[i] = new SqlRow(reserveColumns);
		}
	}

	public this(SqlReader reader)
	{
		while(reader.next())
		{
			writeln("Found Row");
			rows ~= reader.getRow();
		}
	}

	public this(SqlRow[] rows)
	{
		this.rows = rows;
	}
}

unittest
{
	import std.stdio;
	writeln("Testing SqlTable");

	auto reserved = new SqlTable(4, 100);

	reserved.setField(0, 0, SqlValue.SqlString("Hello SqlTable!"));
	auto test = reserved.getField(0, 0).get!string();

	writeln(test);
	assert(test == "Hello SqlTable!");
}
