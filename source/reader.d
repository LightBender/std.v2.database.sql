module std.experimental.database.sql.reader;

import std.typecons;

public interface SqlReader
{
	int FieldCount();
	bool HasRows();

	bool Read();

	Nullable!T GetFieldValue(T)(int fieldOrdinal);
}