module std.experimental.database.sql.table;

import std.array;
import std.datetime;
import std.meta;
import std.typecons;
import std.variant;
import std.uuid;

import std.experimental.database.sql.query;

public final class SqlTable
{
	private Nullable!SqlPrimitive[][] table;

	public this(T...)(T columnTypes)
		if(allSatisfy!(columnTypes, bool, byte, ubyte, short, ushort, int, uint, long, ulong,// cent, ucent, -- Compiler error when included
			float, double, real, ifloat, idouble, ireal, cfloat, cdouble, creal, char, wchar, dchar,
			ubyte[], string, wstring, dstring, UUID, Date, DateTime, TimeOfDay, Duration, SqlTable, Object))
	{
		table.reserve(columnTypes.length);

		for(int i = 0; i < columnTypes.length; i++)
		{
			if(is(columnTypes[i] == bool)) table[i] = new Nullable!(Algebraic!bool)[];
			if(is(columnTypes[i] == byte)) table[i] = new Nullable!(Algebraic!byte)[];
			if(is(columnTypes[i] == ubyte)) table[i] = new Nullable!(Algebraic!ubyte)[];
			if(is(columnTypes[i] == short)) table[i] = new Nullable!(Algebraic!short)[];
			if(is(columnTypes[i] == ushort)) table[i] = new Nullable!(Algebraic!ushort)[];
			if(is(columnTypes[i] == int)) table[i] = new Nullable!(Algebraic!int)[];
			if(is(columnTypes[i] == uint)) table[i] = new Nullable!(Algebraic!uint)[];
			if(is(columnTypes[i] == long)) table[i] = new Nullable!(Algebraic!long)[];
			if(is(columnTypes[i] == ulong)) table[i] = new Nullable!(Algebraic!ulong)[];
			if(is(columnTypes[i] == float)) table[i] = new Nullable!(Algebraic!float)[];
			if(is(columnTypes[i] == double)) table[i] = new Nullable!(Algebraic!double)[];
			if(is(columnTypes[i] == real)) table[i] = new Nullable!(Algebraic!real)[];
			if(is(columnTypes[i] == ifloat)) table[i] = new Nullable!(Algebraic!ifloat)[];
			if(is(columnTypes[i] == idouble)) table[i] = new Nullable!(Algebraic!idouble)[];
			if(is(columnTypes[i] == ireal)) table[i] = new Nullable!(Algebraic!ireal)[];
			if(is(columnTypes[i] == cfloat)) table[i] = new Nullable!(Algebraic!cfloat)[];
			if(is(columnTypes[i] == cdouble)) table[i] = new Nullable!(Algebraic!cdouble)[];
			if(is(columnTypes[i] == creal)) table[i] = new Nullable!(Algebraic!creal)[];
			if(is(columnTypes[i] == ubyte[])) table[i] = new Nullable!(Algebraic!ubyte[])[];
			if(is(columnTypes[i] == string)) table[i] = new Nullable!(Algebraic!string)[];
			if(is(columnTypes[i] == wstring)) table[i] = new Nullable!(Algebraic!wstring)[];
			if(is(columnTypes[i] == dstring)) table[i] = new Nullable!(Algebraic!dstring)[];
			if(is(columnTypes[i] == UUID)) table[i] = new Nullable!(Algebraic!UUID)[];
			if(is(columnTypes[i] == Date)) table[i] = new Nullable!(Algebraic!Date)[];
			if(is(columnTypes[i] == DateTime)) table[i] = new Nullable!(Algebraic!DateTime)[];
			if(is(columnTypes[i] == TimeOfDay)) table[i] = new Nullable!(Algebraic!TimeOfDay)[];
			if(is(columnTypes[i] == Duration)) table[i] = new Nullable!(Algebraic!Duration)[];
			if(is(columnTypes[i] == SqlTable)) table[i] = new Nullable!(Algebraic!SqlTable)[];
			if(is(columnTypes[i] == Object)) table[i] = new Nullable!(Algebraic!Object)[];
		}
	}

	public this(T...)(uint reserveRows, T columnTypes)
		if(allSatisfy!(columnTypes, bool, byte, ubyte, short, ushort, int, uint, long, ulong,// cent, ucent, -- Compiler error when included
			float, double, real, ifloat, idouble, ireal, cfloat, cdouble, creal, char, wchar, dchar,
			ubyte[], string, wstring, dstring, UUID, Date, DateTime, TimeOfDay, Duration, SqlTable, Object))
	{
		table.reserve(columnTypes.length);

		for(int i = 0; i < columnTypes.length; i++)
		{
			if(is(columnTypes[i] == bool)) table[i] = new Nullable!(Algebraic!bool)[];
			if(is(columnTypes[i] == byte)) table[i] = new Nullable!(Algebraic!byte)[];
			if(is(columnTypes[i] == ubyte)) table[i] = new Nullable!(Algebraic!ubyte)[];
			if(is(columnTypes[i] == short)) table[i] = new Nullable!(Algebraic!short)[];
			if(is(columnTypes[i] == ushort)) table[i] = new Nullable!(Algebraic!ushort)[];
			if(is(columnTypes[i] == int)) table[i] = new Nullable!(Algebraic!int)[];
			if(is(columnTypes[i] == uint)) table[i] = new Nullable!(Algebraic!uint)[];
			if(is(columnTypes[i] == long)) table[i] = new Nullable!(Algebraic!long)[];
			if(is(columnTypes[i] == ulong)) table[i] = new Nullable!(Algebraic!ulong)[];
			if(is(columnTypes[i] == float)) table[i] = new Nullable!(Algebraic!float)[];
			if(is(columnTypes[i] == double)) table[i] = new Nullable!(Algebraic!double)[];
			if(is(columnTypes[i] == real)) table[i] = new Nullable!(Algebraic!real)[];
			if(is(columnTypes[i] == ifloat)) table[i] = new Nullable!(Algebraic!ifloat)[];
			if(is(columnTypes[i] == idouble)) table[i] = new Nullable!(Algebraic!idouble)[];
			if(is(columnTypes[i] == ireal)) table[i] = new Nullable!(Algebraic!ireal)[];
			if(is(columnTypes[i] == cfloat)) table[i] = new Nullable!(Algebraic!cfloat)[];
			if(is(columnTypes[i] == cdouble)) table[i] = new Nullable!(Algebraic!cdouble)[];
			if(is(columnTypes[i] == creal)) table[i] = new Nullable!(Algebraic!creal)[];
			if(is(columnTypes[i] == ubyte[])) table[i] = new Nullable!(Algebraic!ubyte[])[];
			if(is(columnTypes[i] == string)) table[i] = new Nullable!(Algebraic!string)[];
			if(is(columnTypes[i] == wstring)) table[i] = new Nullable!(Algebraic!wstring)[];
			if(is(columnTypes[i] == dstring)) table[i] = new Nullable!(Algebraic!dstring)[];
			if(is(columnTypes[i] == UUID)) table[i] = new Nullable!(Algebraic!UUID)[];
			if(is(columnTypes[i] == Date)) table[i] = new Nullable!(Algebraic!Date)[];
			if(is(columnTypes[i] == DateTime)) table[i] = new Nullable!(Algebraic!DateTime)[];
			if(is(columnTypes[i] == TimeOfDay)) table[i] = new Nullable!(Algebraic!TimeOfDay)[];
			if(is(columnTypes[i] == Duration)) table[i] = new Nullable!(Algebraic!Duration)[];
			if(is(columnTypes[i] == Object)) table[i] = new Nullable!(Algebraic!Object)[];

			table[i].reserve(reserveRows);
		}
	}
}

unittest
{
	SqlTable unreserved = new SqlTable!(string, wstring, bool, long)();
	SqlTable reserved = new SqlTable!(string, wstring, bool, long)(100);
}
