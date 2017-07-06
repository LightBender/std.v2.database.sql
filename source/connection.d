module std.experimental.database.sql.connection;

import std.conv;
import std.datetime;
import std.typecons;
import std.variant;
import std.uuid;

import std.experimental.database.sql.query;
import std.experimental.database.sql.reader;
import std.experimental.database.sql.table;

public abstract class SqlConnection
{
    protected immutable string m_uri;
    protected SqlConnectionKeyValue[] m_args;

    protected this(string uri, SqlConnectionKeyValue[] args)
    {
        m_uri = uri;
        if (args !is null)
        {
			//TODO: Want to do something else here
			m_args = args;
        }
        else
        {
            m_args = new SqlConnectionKeyValue[0];
        }
    }

    public final @property string uri() const { return this.m_uri; }
    public final @property SqlConnectionKeyValue[] args() { return this.m_args; }

    public abstract bool open();
    public abstract void close();

    public abstract void queryNoResult(SqlQuery query);
    public abstract SqlReader!T queryReader(T...)(SqlQuery query);
    public abstract SqlTable!T queryTable(T...)(SqlQuery query);

    public abstract void beginTransaction();
    public abstract void commitTransaction();
    public abstract void rollBackTransaction();
}

package struct SqlConnectionKeyValue
{
    public immutable char[64] key;
    public immutable Algebraic!(bool, byte, ubyte, short, ushort, int, uint, long, ulong, float, double, real, string, wstring, dstring) value;

    package this(T)(string key, T value)
        if (is(T == bool) || is(T == byte) || is(T == ubyte) || is(T == short) || is(T == ushort) || is(T == int) ||
            is(T == uint) || is(T == long) || is(T == ulong) ||
            is(T == float) || is(T == double) || is(T == real) || is(T == string) || is(T == wstring) || is(T == dstring))
    in
    {
        assert(key.length < 64, "Parameter 'key' cannot be more than 64 characters.");
    }
    body
    {
        this.key = key;
        this.value = value;
    }
}