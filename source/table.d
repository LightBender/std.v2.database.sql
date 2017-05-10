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

public final class SqlTable(T...)
{
	protected SqlRow!T[] table;

	public SqlValue getField(uint row, uint column)
	{
		return table[row].getField(column);
	}

	public void setField(uint row, uint column, SqlValue value)
	{
		table[row].setField(column, value);
	}

	public this(uint reserveRows)
	{
		table = new SqlRow!T[](reserveRows);
		for(int i = 0; i < reserveRows; i++)
		{
			table[i] = new SqlRow!T();
		}
	}

	public this(SqlReader!T reader)
	{
		while(reader.next())
		{
			table ~= reader.getRow();
		}
	}

	public this(SqlRow!T[] rows)
	{
		table = rows;
	}
}

unittest
{
	import std.stdio;
	writeln("Testing SqlTable");

	auto reserved = new SqlTable!(string, wstring, bool, long)(100);

	reserved.setField(0, 0, SqlValue.SqlString("Hello SqlTable!"));
	auto test = reserved.getField(0, 0).get!string();

	writeln(test);
	assert(test == "Hello SqlTable!");
}
