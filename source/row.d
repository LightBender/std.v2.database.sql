module std.experimental.database.sql.row;

import std.typecons;
import std.variant;

public class SqlRow(T...)
{
	private Nullable!Variant[] fields;

	public this()
	{
		fields = new Nullable!Variant[](T.length);
	}

	public Nullable!T getField(T)(uint ordinal)
	{
		if(fields[ordinal].isNull())
			return Nullable!T();
		return Nullable!T(fields[ordinal].get().get!T());
	}

	public void setField(T)(uint ordinal, Nullable!T value)
	{
		if(value is null)
			fields[ordinal].nullify();
		fields[ordinal] = Variant(value.get());
	}
}

unittest
{
	import std.stdio;

	auto row = new SqlRow!(string, wstring, bool, long)();

	row.setField!string(0, Nullable!string("Hello SqlRow!"));
	auto test = row.getField!string(0);

	writeln(test);
	assert(test == "Hello SqlRow!");
}