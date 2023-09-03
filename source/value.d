module std.v2.database.sql.value;

import std.conv;
import std.datetime;
import std.uuid;

public struct SqlValue
{
    public SqlType type;

    private union {
        string str;
		wstring wstr;
		dstring dstr;
		char chr;
		wchar wchr;
		dchar dchr;
        bool boo;
		byte byt;
		ubyte ubyt;
		ubyte[] ubyta;
		short sho;
		ushort usho;
		int intt;
		uint uin;
		long lon;
		ulong ulon;
		float flo;
		double dou;
		real rea;
		UUID uuid;
        Date dat;
		DateTime datt;
		TimeOfDay tod;
		Duration dur;
		SqlValue[] sqlva;
    }

    public enum SqlType {
        Null,
        String,
        WString,
        DString,
		Char,
		WChar,
		DChar,
        Bool,
 		Byte,
		UByte,
		UByteArray,
		Short,
		UShort,
		Int,
		UInt,
		Long,
		ULong,
		Float,
		Double,
		Real,
		Uuid,
        Date,
		DateTime,
		TimeOfDay,
		Duration,
		SqlValueArray
    }

	@property public bool isNull()
	{
		return type == SqlType.Null;
	}

	public T get(T)()
		if (is(T == string) || is(T == wstring) || is(T == dstring) ||
			is(T == char) || is(T == wchar) || is(T == dchar) ||
			is(T == bool) ||
			is(T == byte) || is(T == ubyte) || is(T == ubyte[]) ||
			is(T == short) || is(T == ushort) ||
			is(T == int) || is(T == uint) ||
			is(T == long) || is(T == ulong) ||
			is(T == float) || is(T == double) || is(T == real) ||
			is(T == UUID) || is(T == Date) || is(T == DateTime) ||
			is(T == TimeOfDay) || is(T == Duration) || is(T == SqlValue[]))
	{
		static if(is(T == string))
		{
			return str;
		}
		else static if(is (T == wstring))
		{
			return wstr;
		}
		else static if(is(T == dstring))
		{
			return dstr;
		}
		else static if(is(T == char))
		{
			return chr;
		}
		else static if(is(T == wchar))
		{
			return wchr;
		}
		else static if(is(T == dchar))
		{
			return dchr;
		}
		else static if(is(T == bool))
		{
			return boo;
		}
		else static if(is(T == byte))
		{
			return byt;
		}
		else static if(is(T == ubyte))
		{
			return ubyt;
		}
		else static if(is(T == ubyte[]))
		{
			return ubyta;
		}
		else static if(is(T == short))
		{
			return sho;
		}
		else static if(is(T == ushort))
		{
			return usho;
		}
		else static if(is(T == int))
		{
			return intt;
		}
		else static if(is(T == uint))
		{
			return uin;
		}
		else static if(is(T == long))
		{
			return lon;
		}
		else static if(is(T == ulong))
		{
			return ulon;
		}
		else static if(is(T == float))
		{
			return flo;
		}
		else static if(is(T == double))
		{
			return dou;
		}
		else static if(is(T == real))
		{
			return rea;
		}
		else static if(is(T == UUID))
		{
			return uuid;
		}
		else static if(is(T == Date))
		{
			return dat;
		}
		else static if(is(T == DateTime))
		{
			return datt;
		}
		else static if(is(T == TimeOfDay))
		{
			return tod;
		}
		else static if(is(T == Duration))
		{
			return dur;
		}
		else static if(is(T == SqlValue[]))
		{
			return sqlva;
		}
	}

	public void opAssign(SqlValue rhs)
	{
		type = rhs.type;

		if(type == SqlType.String)
		{
			this.str = rhs.str;
		}
		else if(type == SqlType.WString)
		{
			this.wstr = rhs.wstr;
		}
		else if(type == SqlType.DString)
		{
			this.dstr = rhs.dstr;
		}
		else if(type == SqlType.Char)
		{
			this.chr = rhs.chr;
		}
		else if(type == SqlType.WChar)
		{
			this.wchr = rhs.wchr;
		}
		else if(type == SqlType.DChar)
		{
			this.dchr = rhs.dchr;
		}
		else if(type == SqlType.Bool)
		{
			this.boo = rhs.boo;
		}
		else if(type == SqlType.Byte)
		{
			this.byt = rhs.byt;
		}
		else if(type == SqlType.UByte)
		{
			this.ubyt = rhs.ubyt;
		}
		else if(type == SqlType.UByteArray)
		{
			this.ubyta = rhs.ubyta;
		}
		else if(type == SqlType.Short)
		{
			this.sho = rhs.sho;
		}
		else if(type == SqlType.UShort)
		{
			this.usho = rhs.usho;
		}
		else if(type == SqlType.Int)
		{
			this.intt = rhs.intt;
		}
		else if(type == SqlType.UInt)
		{
			this.uin = rhs.uin;
		}
		else if(type == SqlType.Long)
		{
			this.lon = rhs.lon;
		}
		else if(type == SqlType.ULong)
		{
			this.ulon = rhs.ulon;
		}
		else if(type == SqlType.Float)
		{
			this.flo = rhs.flo;
		}
		else if(type == SqlType.Double)
		{
			this.dou = rhs.dou;
		}
		else if(type == SqlType.Real)
		{
			this.rea = rhs.rea;
		}
		else if(type == SqlType.Uuid)
		{
			this.uuid = rhs.uuid;
		}
		else if(type == SqlType.Date)
		{
			this.dat = rhs.dat;
		}
		else if(type == SqlType.DateTime)
		{
			this.datt = rhs.datt;
		}
		else if(type == SqlType.TimeOfDay)
		{
			this.tod = rhs.tod;
		}
		else if(type == SqlType.Duration)
		{
			this.dur = rhs.dur;
		}
		else if(type == SqlType.SqlValueArray)
		{
			this.sqlva = rhs.sqlva;
		}
	}

    public static
	{

		SqlValue SqlNull() {
			SqlValue ret;
			ret.type = SqlType.Null;
			return ret;
		}

		SqlValue SqlString(string value) {
			SqlValue ret;
			ret.type = SqlType.String;
			ret.str = value;
			return ret;
		}

		SqlValue SqlWString(wstring value) {
			SqlValue ret;
			ret.type = SqlType.WString;
			ret.wstr = value;
			return ret;
		}

		SqlValue SqlDString(dstring value) {
			SqlValue ret;
			ret.type = SqlType.DString;
			ret.dstr = value;
			return ret;
		}

		SqlValue SqlChar(char value) {
			SqlValue ret;
			ret.type = SqlType.Char;
			ret.chr = value;
			return ret;
		}

		SqlValue SqlWChar(wchar value) {
			SqlValue ret;
			ret.type = SqlType.WChar;
			ret.wchr = value;
			return ret;
		}

		SqlValue SqlDChar(dchar value) {
			SqlValue ret;
			ret.type = SqlType.DChar;
			ret.dchr = value;
			return ret;
		}

		SqlValue SqlBool(bool value) {
			SqlValue ret;
			ret.type = SqlType.Bool;
			ret.boo = value;
			return ret;
		}

		SqlValue SqlByte(byte value) {
			SqlValue ret;
			ret.type = SqlType.Byte;
			ret.byt = value;
			return ret;
		}

		SqlValue SqlUByte(ubyte value) {
			SqlValue ret;
			ret.type = SqlType.UByte;
			ret.ubyt = value;
			return ret;
		}

		SqlValue SqlUByteArray(ubyte[] value) {
			SqlValue ret;
			ret.type = SqlType.UByteArray;
			ret.ubyta = value;
			return ret;
		}

		SqlValue SqlShort(short value) {
			SqlValue ret;
			ret.type = SqlType.Short;
			ret.sho = value;
			return ret;
		}

		SqlValue SqlUShort(ushort value) {
			SqlValue ret;
			ret.type = SqlType.UShort;
			ret.usho = value;
			return ret;
		}

		SqlValue SqlInt(int value) {
			SqlValue ret;
			ret.type = SqlType.Int;
			ret.intt = value;
			return ret;
		}

		SqlValue SqlUInt(uint value) {
			SqlValue ret;
			ret.type = SqlType.UInt;
			ret.uin = value;
			return ret;
		}

		SqlValue SqlLong(long value) {
			SqlValue ret;
			ret.type = SqlType.Long;
			ret.lon = value;
			return ret;
		}

		SqlValue SqlULong(ulong value) {
			SqlValue ret;
			ret.type = SqlType.ULong;
			ret.ulon = value;
			return ret;
		}

		SqlValue SqlFloat(float value) {
			SqlValue ret;
			ret.type = SqlType.Float;
			ret.flo = value;
			return ret;
		}

		SqlValue SqlDouble(double value) {
			SqlValue ret;
			ret.type = SqlType.Double;
			ret.dou = value;
			return ret;
		}

		SqlValue SqlReal(real value) {
			SqlValue ret;
			ret.type = SqlType.Real;
			ret.rea = value;
			return ret;
		}

		SqlValue SqlUuid(UUID value) {
			SqlValue ret;
			ret.type = SqlType.Uuid;
			ret.uuid = value;
			return ret;
		}

		SqlValue SqlDate(Date value) {
			SqlValue ret;
			ret.type = SqlType.Date;
			ret.dat = value;
			return ret;
		}

		SqlValue SqlDateTime(DateTime value) {
			SqlValue ret;
			ret.type = SqlType.DateTime;
			ret.datt = value;
			return ret;
		}

		SqlValue SqlTimeOfDay(TimeOfDay value) {
			SqlValue ret;
			ret.type = SqlType.TimeOfDay;
			ret.tod = value;
			return ret;
		}

		SqlValue SqlDuration(Duration value) {
			SqlValue ret;
			ret.type = SqlType.Duration;
			ret.dur = value;
			return ret;
		}

		SqlValue SqlValueArray(SqlValue[] value) {
			SqlValue ret;
			ret.type = SqlType.SqlValueArray;
			ret.sqlva = value;
			return ret;
		}
    }
}

unittest
{
	import std.stdio;
	writeln("Testing SqlValue NULL");

	auto sqlv = SqlValue.SqlNull();
	assert(sqlv.isNull == true, "SqlValue.isNull equals false!");
}

unittest
{
	import std.stdio;
	writeln("Testing SqlValueArray");

	auto sqlva = SqlValue.SqlValueArray([SqlValue.SqlString("Hello"), SqlValue.SqlBool(true), SqlValue.SqlInt(1)]);
	assert(sqlva.get!(SqlValue[]).length == 3, "SqlValueArray length is not 3!");

	auto arr = sqlva.get!(SqlValue[])();
	writeln(arr[0].get!string());
}

unittest
{
	import std.stdio;
	writeln("Testing SqlValues");

	auto str = SqlValue.SqlString("Hello World!");
	assert(str.get!string() == "Hello World!");

	auto wstr = SqlValue.SqlWString("Hello World!");
	assert(wstr.get!wstring() == "Hello World!");

	auto dstr = SqlValue.SqlDString("Hello World!");
	assert(dstr.get!dstring() == "Hello World!");

	auto chr = SqlValue.SqlChar('a');
	assert(chr.get!char() == 'a');

	auto wchr = SqlValue.SqlWChar('a');
	assert(wchr.get!wchar() == 'a');

	auto dchr = SqlValue.SqlDChar('a');
	assert(dchr.get!dchar() == 'a');

	auto boo = SqlValue.SqlBool(true);
	assert(boo.get!bool() == true);

	auto byt = SqlValue.SqlByte(0x0);
	assert(byt.get!byte() == 0x0);

	auto ubyt = SqlValue.SqlUByte(0x1);
	assert(ubyt.get!ubyte() == 0x1);

	auto ubyta = SqlValue.SqlUByteArray([0x1, 0x0, 0x2]);
	assert(ubyta.get!(ubyte[])() == [0x1, 0x0, 0x2]);

	auto sho = SqlValue.SqlShort(-1);
	assert(sho.get!short() == -1);

	auto usho = SqlValue.SqlUShort(1);
	assert(usho.get!ushort() == 1);

	auto intt = SqlValue.SqlInt(-1);
	assert(intt.get!int() == -1);

	auto uin = SqlValue.SqlUInt(1);
	assert(uin.get!uint() == 1);

	auto lon = SqlValue.SqlLong(-1);
	assert(lon.get!long() == -1);

	auto ulon = SqlValue.SqlULong(1);
	assert(ulon.get!ulong() == 1);

	auto flo = SqlValue.SqlFloat(1.0f);
	assert(flo.get!float() == 1.0f);

	auto dou = SqlValue.SqlDouble(-1.0f);
	assert(dou.get!double() == -1.0f);

	auto rea = SqlValue.SqlReal(1.0L);
	assert(rea.get!real() == 1.0L);

	auto uuid = SqlValue.SqlUuid(UUID("00000000-0000-0000-0000-000000000001"));
	assert(uuid.get!UUID() == UUID("00000000-0000-0000-0000-000000000001"));

	auto dat = SqlValue.SqlDate(Date(2000, 1, 1));
	assert(dat.get!Date() == Date(2000, 1, 1));

	auto datt = SqlValue.SqlDateTime(DateTime(2000, 1, 1, 0, 0, 0));
	assert(datt.get!DateTime() == DateTime(2000, 1, 1, 0, 0, 0));

	auto tod = SqlValue.SqlTimeOfDay(TimeOfDay(0, 0, 0));
	assert(tod.get!TimeOfDay() == TimeOfDay(0, 0, 0));

	auto dura = SqlValue.SqlDuration(dur!"days"(1));
	assert(dura.get!Duration() == dur!"days"(1));
}