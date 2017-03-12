module std.experimental.database.sql.connection;

import std.conv;
import std.datetime;
import std.typecons;
import std.variant;
import std.uuid;

public struct SqlConnection
{
    public immutable char[253] hostname;
    public immutable ushort port;
    public immutable char[128] username;
	public immutable char[128] password;

    public immutable SqlConnectionKeyValue[] args;

    public this(T...)(string hostname, ushort port, string username, string password, T args)
	in
	{
		assert(hostname < 253, "Parameter 'hostname' must contain no more than 253 characters.");
		assert(username < 128, "Parameter 'username' must contain no more than 128 characters.");
		assert(password < 128, "Parameter 'password' must contain no more than 128 characters.");
		assert(args.length != 0 && args.length % 2 == 0, "Parameter 'args' must contain an even number of items.");
	}
	body
	{
		this.hostname = hostname;
		this.port = port;
		this.username = username;
		this.password = password;

		if (args.length != 0)
		{
			args = new SqlConnectionKeyValue[args.length % 2];
			for(int i = 0; i < args.length; i+2)
			{
				args[i/2] = SqlConnectionKeyValue(to!string(args[i]), args[i+1]);
			}
		}
    }
}

public struct SqlConnectionKeyValue
{
    public immutable char[64] key;
    public immutable Algebraic!(bool, byte, ubyte, short, ushort, int, uint, long, ulong, float, double, real, string, wstring, dstring) value;

	package this(T)(string key, T value)
		if (is(T == bool) || is(T == byte) || is(T == ubyte) || is(T == short) || is(T == ushort) || is(T == int) || is(T == uint) || is(T == long) || is(T == ulong) ||
			is(T == float) || is(T == double) || is(T == real) || is(T == string) || is(T == wstring) || is(T == dstring))
	in
	{
		assert(key.length < 64, "Parameter 'key' cannot be more than 6 characters.");
	}
	body
	{
		this.key = key;
		this.value = value;
	}
}