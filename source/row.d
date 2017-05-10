module std.experimental.database.sql.row;

import std.typecons;
import std.variant;

import std.experimental.database.sql.value;

public class SqlRow(T...)
{
	private SqlValue[] fields;

	public this()
	{
		fields = new SqlValue[](T.length);
	}

	public SqlValue getField(uint ordinal)
	{
		return fields[ordinal];
	}

	public void setField(uint ordinal, SqlValue value)
	{
		fields[ordinal] = value;
	}
}

unittest
{
	import std.stdio;

	auto row = new SqlRow!(string, wstring, bool, long)();

	row.setField(0, SqlValue.SqlString("Hello SqlRow!"));
	auto test = row.getField(0).get!string();

	writeln(test);
	assert(test == "Hello SqlRow!");
}