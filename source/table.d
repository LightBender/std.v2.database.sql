module std.experimental.database.sql.table;

import std.array;
import std.datetime;
import std.meta;
import std.typecons;
import std.variant;
import std.uuid;

public abstract class SqlTableBase
{
	protected Nullable!Variant[][] table;

	public Nullable!T getField(T)(uint row, uint column)
	{
		auto value = table[row][column];
		if(value.isNull())
			return Nullable!T();
		return Nullable!T(value.get().get!T());
	}

	public void setField(T)(uint row, uint column, Nullable!T value)
	{
		if(value is null)
			table[row][column].nullify();
		table[row][column] = Variant(value.get());
	}
}

public final class SqlTable(T...) : SqlTableBase
{
	public this()
	{
		table = new Nullable!Variant[][](T.length, 0);
	}

	public this(uint reserveRows)
	{
		table = new Nullable!Variant[][](T.length, reserveRows);
	}
}

unittest
{
	import std.stdio;

	SqlTableBase unreserved = new SqlTable!(string, wstring, bool, long)();
	SqlTableBase reserved = new SqlTable!(string, wstring, bool, long)(100);

	reserved.setField!string(0,0,Nullable!string("Hello World!"));
	auto test = reserved.getField!string(0,0);

	writeln(test);
	assert(test == "Hello World!");
}
