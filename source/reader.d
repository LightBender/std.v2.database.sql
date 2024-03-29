module std.v2.database.sql.reader;

import std.typecons;

import etc.c.odbc.sqlucode;

import std.v2.database.sql.row;

public interface ISqlReader
{
	@property bool hasRows();

	bool next();

	Nullable!T getField(T)(int fieldOrdinal);
	SqlRow getRow();
}