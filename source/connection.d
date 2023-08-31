module std.experimental.database.sql.connection;

import std.conv;
import std.datetime;
import std.typecons;
import std.variant;
import std.uuid;

import etc.c.odbc.sqlucode;

import std.experimental.database.sql.command;
import std.experimental.database.sql.reader;
import std.experimental.database.sql.table;

public interface ISqlConnection
{
    bool open();
    void close();

    void queryNoResult(SqlCommand query);
    SqlReader[] queryReader(SqlCommand query);
    SqlTable[] queryTable(SqlCommand query);

    void beginTransaction();
    void commitTransaction();
    void rollBackTransaction();
}
