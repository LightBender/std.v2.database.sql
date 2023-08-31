module std.experimental.database.sql.reader;

import std.typecons;

import etc.c.odbc.sqlucode;

import std.experimental.database.sql.row;

public interface SqlReader
{
	@property bool hasRows();

	bool next();

	Nullable!T getField(T)(int fieldOrdinal);
	SqlRow getRow();
}