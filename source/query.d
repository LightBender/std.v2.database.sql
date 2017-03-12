module std.experimental.database.sql.query;

import std.datetime;
import std.typecons;
import std.variant;
import std.uuid;

import std.experimental.database.sql.connection;
import std.experimental.database.sql.table;

public alias SqlPrimitive = Algebraic!(bool, byte, ubyte, short, ushort, int, uint, long, ulong,// cent, ucent, -- Compiler error when included
		float, double, real, ifloat, idouble, ireal, cfloat, cdouble, creal, char, wchar, dchar,
		ubyte[], string, wstring, dstring, UUID, Date, DateTime, TimeOfDay, Duration, SqlTable);

public enum SqlParameterDirection
{
	Input,
	InputOutput,
	Output,
	Return,
}

struct SqlParameter
{
    Nullable!SqlPrimitive value;
    bool nullable;
    int length;
    ubyte precision;
    ubyte scale;
    string udtName;
    SqlParameterDirection direction;
}

public struct SqlQuery
{
    public string query;
    public int timeout;
    public SqlConnection conn;
    public SqlParameter[] params;
}

public struct SqlStoredProcedure
{
    public string procedure;
    public int timeout;
    public SqlConnection conn;
    public SqlParameter[] params;
}
