module std.experimental.database.sql.reader;

import std.typecons;

import std.experimental.database.sql.row;

public interface SqlReader(T...)
{
	@property bool hasRows();

	bool next();

	Nullable!T getField(T)(int fieldOrdinal);
	SqlRow!T getRow();
}