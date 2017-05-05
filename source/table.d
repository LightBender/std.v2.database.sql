module std.experimental.database.sql.table;

import std.array;
import std.datetime;
import std.meta;
import std.typecons;
import std.variant;
import std.uuid;

import std.experimental.database.sql.reader;
import std.experimental.database.sql.row;

public final class SqlTable(T...)
{
	protected SqlRow!T[] table;

	public Nullable!T getField(T)(uint row, uint column)
	{
		return table[row].getField!T(column);
	}

	public void setField(T)(uint row, uint column, Nullable!T value)
	{
		table[row].setField!T(column, value);
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

	auto reserved = new SqlTable!(string, wstring, bool, long)(100);

	reserved.setField!string(0, 0, Nullable!string("Hello SqlTable!"));
	auto test = reserved.getField!string(0, 0);

	writeln(test);
	assert(test == "Hello SqlTable!");
}
