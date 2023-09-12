module std.v2.database.sql.odbc;

public import etc.c.odbc.sql;
public import etc.c.odbc.sqlext;
public import etc.c.odbc.sqltypes;
public import etc.c.odbc.sqlucode;

import std.ascii;
import std.conv;
import std.stdio;
import std.string;
import std.typecons;
import std.utf;

version(Windows) pragma(lib, "odbc32.lib");

// Wrap C Methods with a D-style interface.

public struct ODBCHandle {
    private SQLHANDLE handle;
    private short handleType;

    bool isValid() @trusted { return handle !is null; }
}

public class ODBCException : Exception {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
}

public:
    ODBCHandle ODBCAllocHandle() @trusted
    {
        SQLHANDLE outHandle;
        auto rv = SQLAllocHandle(SQL_HANDLE_ENV, null, &outHandle);
		if (rv == SQL_ERROR || outHandle == null) throw new ODBCException("Unable to allocate enivronment handle.");
        ODBCHandle ret = { handle:outHandle, handleType:SQL_HANDLE_ENV };
        return ret;
    }

    ODBCHandle ODBCAllocHandle(short HandleType, ODBCHandle InputHandle) @trusted
    {
        if (HandleType == SQL_HANDLE_ENV) {
            throw new ODBCException("HandleType must not be SQL_HANDLE_ENV.");
        }

        SQLHANDLE outHandle;
        ODBCThrowOnError(SQLAllocHandle(HandleType, InputHandle.handle, &outHandle), InputHandle, "Driver Error: Invalid Handle");
        ODBCHandle ret = { handle:outHandle, handleType:HandleType };
        return ret;
    }

	__gshared short ODBCBindCol(void* StatementHandle, ushort ColumnNumber, short TargetType, void* TargetValue, long BufferLength, long* StrLen_or_Ind);
	__gshared short ODBCCancel(void* StatementHandle);
	__gshared short ODBCCancelHandle(short HandleType, void* InputHandle);
	__gshared short ODBCCloseCursor(void* StatementHandle);
	__gshared short ODBCColAttribute(void* StatementHandle, ushort ColumnNumber, ushort FieldIdentifier, void* CharacterAttribute, short BufferLength, short* StringLength, long* NumericAttribute);
	__gshared short ODBCColumns(void* StatementHandle, ubyte* CatalogName, short NameLength1, ubyte* SchemaName, short NameLength2, ubyte* TableName, short NameLength3, ubyte* ColumnName, short NameLength4);
	__gshared short ODBCCompleteAsync(short HandleType, void* Handle, short* AsyncRetCodePtr);
	__gshared short ODBCConnect(void* ConnectionHandle, ubyte* ServerName, short NameLength1, ubyte* UserName, short NameLength2, ubyte* Authentication, short NameLength3);
	__gshared short ODBCCopyDesc(void* SourceDescHandle, void* TargetDescHandle);
	__gshared short ODBCDataSources(void* EnvironmentHandle, ushort Direction, ubyte* ServerName, short BufferLength1, short* NameLength1Ptr, ubyte* Description, short BufferLength2, short* NameLength2Ptr);
	__gshared short ODBCDescribeCol(void* StatementHandle, ushort ColumnNumber, ubyte* ColumnName, short BufferLength, short* NameLength, short* DataType, ulong* ColumnSize, short* DecimalDigits, short* Nullable);

	void ODBCDisconnect(ODBCHandle ConnectionHandle) @trusted {
        if (ConnectionHandle.handleType != SQL_HANDLE_DBC) {
            throw new ODBCException("Invalid handle provided. Please provide a valid Connection handle.");
        }

        ODBCThrowOnError(SQLDisconnect(ConnectionHandle.handle), ConnectionHandle, "Error while disconnecting:");
    }

	__gshared short ODBCEndTran(short HandleType, void* Handle, short CompletionType);
	__gshared short ODBCError(void* EnvironmentHandle, void* ConnectionHandle, void* StatementHandle, ubyte* Sqlstate, int* NativeError, ubyte* MessageText, short BufferLength, short* TextLength);
	__gshared short ODBCExecDirect(void* StatementHandle, ubyte* StatementText, int TextLength);
	__gshared short ODBCExecute(void* StatementHandle);
	__gshared short ODBCFetch(void* StatementHandle);
	__gshared short ODBCFetchScroll(void* StatementHandle, short FetchOrientation, long FetchOffset);

	void ODBCFreeHandle(ODBCHandle handle) @trusted
    {
        ODBCThrowOnError(SQLFreeHandle(handle.handleType, handle.handle), handle, "Error freeing handle:");
    }

	__gshared short ODBCGetConnectAttr(void* ConnectionHandle, int Attribute, void* Value, int BufferLength, int* StringLengthPtr);
	__gshared short ODBCGetCursorName(void* StatementHandle, ubyte* CursorName, short BufferLength, short* NameLengthPtr);
	__gshared short ODBCGetData(void* StatementHandle, ushort ColumnNumber, short TargetType, void* TargetValue, long BufferLength, long* StrLen_or_IndPtr);
	__gshared short ODBCGetDescField(void* DescriptorHandle, short RecNumber, short FieldIdentifier, void* Value, int BufferLength, int* StringLength);
	__gshared short ODBCGetDescRec(void* DescriptorHandle, short RecNumber, ubyte* Name, short BufferLength, short* StringLengthPtr, short* TypePtr, short* SubTypePtr, long* LengthPtr, short* PrecisionPtr, short* ScalePtr, short* NullablePtr);
	__gshared short ODBCGetDiagField(short HandleType, void* Handle, short RecNumber, short DiagIdentifier, void* DiagInfo, short BufferLength, short* StringLength);
	__gshared short ODBCGetDiagRec(short HandleType, void* Handle, short RecNumber, ubyte* Sqlstate, int* NativeError, ubyte* MessageText, short BufferLength, short* TextLength);
	__gshared short ODBCGetEnvAttr(void* EnvironmentHandle, int Attribute, void* Value, int BufferLength, int* StringLength);
	__gshared short ODBCGetFunctions(void* ConnectionHandle, ushort FunctionId, ushort* Supported);
	__gshared short ODBCGetInfo(void* ConnectionHandle, ushort InfoType, void* InfoValue, short BufferLength, short* StringLengthPtr);
	__gshared short ODBCGetStmtAttr(void* StatementHandle, int Attribute, void* Value, int BufferLength, int* StringLength);
	__gshared short ODBCGetTypeInfo(void* StatementHandle, short DataType);
	__gshared short ODBCNumResultCols(void* StatementHandle, short* ColumnCount);
	__gshared short ODBCParamData(void* StatementHandle, void** Value);
	__gshared short ODBCPrepare(void* StatementHandle, ubyte* StatementText, int TextLength);
	__gshared short ODBCPutData(void* StatementHandle, void* Data, long StrLen_or_Ind);
	__gshared short ODBCRowCount(void* StatementHandle, long* RowCount);
	__gshared short ODBCSetConnectAttr(void* ConnectionHandle, int Attribute, void* Value, int StringLength);
	__gshared short ODBCSetCursorName(void* StatementHandle, ubyte* CursorName, short NameLength);
	__gshared short ODBCSetDescField(void* DescriptorHandle, short RecNumber, short FieldIdentifier, void* Value, int BufferLength);
	__gshared short ODBCSetDescRec(void* DescriptorHandle, short RecNumber, short Type, short SubType, long Length, short Precision, short Scale, void* Data, long* StringLength, long* Indicator);

	void ODBCSetEnvAttr(ODBCHandle environmentHandle, int attribute, int value) @trusted {
        if (environmentHandle.handleType != SQL_HANDLE_ENV) {
            throw new ODBCException("Invalid handle provided. Please provide a valid Environment handle.");
        }
        ODBCThrowOnError(SQLSetEnvAttr(environmentHandle.handle, attribute, cast(void*)value, 0), environmentHandle, "Error in SetEnvAttr:");
    }

	void ODBCSetEnvAttr(ODBCHandle environmentHandle, int attribute, string value) @trusted {
        if (environmentHandle.handleType != SQL_HANDLE_ENV) {
            throw new ODBCException("Invalid handle provided. Please provide a valid Environment handle.");
        }

		int len = cast(int)(cast(ubyte[])value).length+1;
        ODBCThrowOnError(SQLSetEnvAttr(environmentHandle.handle, attribute, cast(void*)value.toStringz(), cast(int)len), environmentHandle, "Error in SetEnvAttr:");
    }

	void ODBCSetEnvAttr(ODBCHandle environmentHandle, int attribute, ubyte[] value) @trusted {
        if (environmentHandle.handleType != SQL_HANDLE_ENV) {
            throw new ODBCException("Invalid handle provided. Please provide a valid Environment handle.");
        }
        ODBCThrowOnError(SQLSetEnvAttr(environmentHandle.handle, attribute, cast(void*)value.ptr, cast(int)value.length), environmentHandle, "Error in SetEnvAttr:");
    }

	__gshared short ODBCSetStmtAttr(void* StatementHandle, int Attribute, void* Value, int StringLength);
	__gshared short ODBCSpecialColumns(void* StatementHandle, ushort IdentifierType, ubyte* CatalogName, short NameLength1, ubyte* SchemaName, short NameLength2, ubyte* TableName, short NameLength3, ushort Scope, ushort Nullable);
	__gshared short ODBCStatistics(void* StatementHandle, ubyte* CatalogName, short NameLength1, ubyte* SchemaName, short NameLength2, ubyte* TableName, short NameLength3, ushort Unique, ushort Reserved);
	__gshared short ODBCTables(void* StatementHandle, ubyte* CatalogName, short NameLength1, ubyte* SchemaName, short NameLength2, ubyte* TableName, short NameLength3, ubyte* TableType, short NameLength4);
	__gshared short ODBCTransact(void* EnvironmentHandle, void* ConnectionHandle, ushort CompletionType);

//Unicode
	__gshared short SQLDriverConnect(void* hdbc, void* hwnd, ubyte* szConnStrIn, short cchConnStrIn, ubyte* szConnStrOut, short cchConnStrOutMax, short* pcchConnStrOut, ushort fDriverCompletion);
	__gshared short SQLBrowseConnect(void* hdbc, ubyte* szConnStrIn, short cchConnStrIn, ubyte* szConnStrOut, short cchConnStrOutMax, short* pcchConnStrOut);
	__gshared short SQLBulkOperations(void* StatementHandle, short Operation);
	__gshared short SQLColAttributes(void* hstmt, ushort icol, ushort fDescType, void* rgbDesc, short cbDescMax, short* pcbDesc, long* pfDesc);
	__gshared short SQLColumnPrivileges(void* hstmt, ubyte* szCatalogName, short cchCatalogName, ubyte* szSchemaName, short cchSchemaName, ubyte* szTableName, short cchTableName, ubyte* szColumnName, short cchColumnName);
	__gshared short SQLDescribeParam(void* hstmt, ushort ipar, short* pfSqlType, ulong* pcbParamDef, short* pibScale, short* pfNullable);
	__gshared short SQLExtendedFetch(void* hstmt, ushort fFetchType, long irow, ulong* pcrow, ushort* rgfRowStatus);
	__gshared short SQLForeignKeys(void* hstmt, ubyte* szPkCatalogName, short cchPkCatalogName, ubyte* szPkSchemaName, short cchPkSchemaName, ubyte* szPkTableName, short cchPkTableName, ubyte* szFkCatalogName, short cchFkCatalogName, ubyte* szFkSchemaName, short cchFkSchemaName, ubyte* szFkTableName, short cchFkTableName);
	__gshared short SQLMoreResults(void* hstmt);
	__gshared short SQLNativeSql(void* hdbc, ubyte* szSqlStrIn, int cchSqlStrIn, ubyte* szSqlStr, int cchSqlStrMax, int* pcbSqlStr);
	__gshared short SQLNumParams(void* hstmt, short* pcpar);
	__gshared short SQLParamOptions(void* hstmt, ulong crow, ulong* pirow);
	__gshared short SQLPrimaryKeys(void* hstmt, ubyte* szCatalogName, short cchCatalogName, ubyte* szSchemaName, short cchSchemaName, ubyte* szTableName, short cchTableName);
	__gshared short SQLProcedureColumns(void* hstmt, ubyte* szCatalogName, short cchCatalogName, ubyte* szSchemaName, short cchSchemaName, ubyte* szProcName, short cchProcName, ubyte* szColumnName, short cchColumnName);
	__gshared short SQLProcedures(void* hstmt, ubyte* szCatalogName, short cchCatalogName, ubyte* szSchemaName, short cchSchemaName, ubyte* szProcName, short cchProcName);
	__gshared short SQLSetPos(void* hstmt, ulong irow, ushort fOption, ushort fLock);
	__gshared short SQLTablePrivileges(void* hstmt, ubyte* szCatalogName, short cchCatalogName, ubyte* szSchemaName, short cchSchemaName, ubyte* szTableName, short cchTableName);
	__gshared short SQLDrivers(void* henv, ushort fDirection, ubyte* szDriverDesc, short cchDriverDescMax, short* pcchDriverDesc, ubyte* szDriverAttributes, short cchDrvrAttrMax, short* pcchDrvrAttr);
	__gshared short SQLBindParameter(void* hstmt, ushort ipar, short fParamType, short fCType, short fSqlType, ulong cbColDef, short ibScale, void* rgbValue, long cbValueMax, long* pcbValue);
	__gshared short SQLAllocHandleStd(short fHandleType, void* hInput, void** phOutput);
	__gshared short SQLSetScrollOptions(void* hstmt, ushort fConcurrency, long crowKeyset, ushort crowRowset);
	__gshared short TraceOpenLogFile(ushort* szFileName, ushort* lpwszOutputMsg, uint cbOutputMsg);
	__gshared short TraceCloseLogFile();
	__gshared void TraceReturn(short, short);
	__gshared uint TraceVersion();
	__gshared short TraceVSControl(uint);
	__gshared int ODBCSetTryWaitValue(uint dwValue);
	__gshared uint ODBCGetTryWaitValue();
	__gshared short SQLColAttributeW(void* hstmt, ushort iCol, ushort iField, void* pCharAttr, short cbDescMax, short* pcbCharAttr, long* pNumAttr);
	__gshared short SQLColAttributesW(void* hstmt, ushort icol, ushort fDescType, void* rgbDesc, short cbDescMax, short* pcbDesc, long* pfDesc);
	__gshared short SQLConnectW(void* hdbc, ushort* szDSN, short cchDSN, ushort* szUID, short cchUID, ushort* szAuthStr, short cchAuthStr);
	__gshared short SQLDescribeColW(void* hstmt, ushort icol, ushort* szColName, short cchColNameMax, short* pcchColName, short* pfSqlType, ulong* pcbColDef, short* pibScale, short* pfNullable);
	__gshared short SQLErrorW(void* henv, void* hdbc, void* hstmt, ushort* wszSqlState, int* pfNativeError, ushort* wszErrorMsg, short cchErrorMsgMax, short* pcchErrorMsg);
	__gshared short SQLExecDirectW(void* hstmt, ushort* szSqlStr, int TextLength);
	__gshared short SQLGetConnectAttrW(void* hdbc, int fAttribute, void* rgbValue, int cbValueMax, int* pcbValue);
	__gshared short SQLGetCursorNameW(void* hstmt, ushort* szCursor, short cchCursorMax, short* pcchCursor);
	__gshared short SQLSetDescFieldW(void* DescriptorHandle, short RecNumber, short FieldIdentifier, void* Value, int BufferLength);
	__gshared short SQLGetDescFieldW(void* hdesc, short iRecord, short iField, void* rgbValue, int cbBufferLength, int* StringLength);
	__gshared short SQLGetDescRecW(void* hdesc, short iRecord, ushort* szName, short cchNameMax, short* pcchName, short* pfType, short* pfSubType, long* pLength, short* pPrecision, short* pScale, short* pNullable);
	__gshared short SQLPrepareW(void* hstmt, ushort* szSqlStr, int cchSqlStr);
	void ODBCSetConnectAttr(ODBCHandle connectionHandle, int attribute, int value) @trusted {
        if (connectionHandle.handleType != SQL_HANDLE_DBC) {
            throw new ODBCException("Invalid handle provided. Please provide a valid Connection handle.");
        }

        ODBCThrowOnError(SQLSetConnectAttrW(connectionHandle.handle, attribute, cast(void*)value, SQL_IS_INTEGER), connectionHandle, "Error in SetConnectAttr:");
    }

	void ODBCSetConnectAttr(ODBCHandle connectionHandle, int attribute, uint value) @trusted {
        if (connectionHandle.handleType != SQL_HANDLE_DBC) {
            throw new ODBCException("Invalid handle provided. Please provide a valid Connection handle.");
        }

        ODBCThrowOnError(SQLSetConnectAttrW(connectionHandle.handle, attribute, cast(void*)value, SQL_IS_UINTEGER), connectionHandle, "Error in SetConnectAttr:");
    }

	void ODBCSetConnectAttr(ODBCHandle connectionHandle, int attribute, string value) @trusted {
        if (connectionHandle.handleType != SQL_HANDLE_DBC) {
            throw new ODBCException("Invalid handle provided. Please provide a valid Connection handle.");
        }

        auto wcs = value.toUTF16;
        ODBCThrowOnError(SQLSetConnectAttrW(connectionHandle.handle, attribute, cast(wchar*)value.toUTF16z, cast(int)value.length), connectionHandle, "Error in SetConnectAttr:");
    }

	void ODBCSetConnectAttr(ODBCHandle connectionHandle, int attribute, ubyte[] value) @trusted {
        if (connectionHandle.handleType != SQL_HANDLE_DBC) {
            throw new ODBCException("Invalid handle provided. Please provide a valid Connection handle.");
        }

        ODBCThrowOnError(SQLSetConnectAttrW(connectionHandle.handle, attribute, value.ptr, cast(int)-value.length), connectionHandle, "Error in SetConnectAttr:");
    }

	__gshared short SQLSetCursorNameW(void* hstmt, ushort* szCursor, short cchCursor);
	__gshared short SQLColumnsW(void* hstmt, ushort* szCatalogName, short cchCatalogName, ushort* szSchemaName, short cchSchemaName, ushort* szTableName, short cchTableName, ushort* szColumnName, short cchColumnName);
	__gshared short SQLGetConnectOptionW(void* hdbc, ushort fOption, void* pvParam);
	__gshared short SQLGetInfoW(void* hdbc, ushort fInfoType, void* rgbInfoValue, short cbInfoValueMax, short* pcbInfoValue);
	__gshared short SQLGetTypeInfoW(void* StatementHandle, short DataType);
	__gshared short SQLSetConnectOptionW(void* hdbc, ushort fOption, ulong vParam);
	__gshared short SQLSpecialColumnsW(void* hstmt, ushort fColType, ushort* szCatalogName, short cchCatalogName, ushort* szSchemaName, short cchSchemaName, ushort* szTableName, short cchTableName, ushort fScope, ushort fNullable);
	__gshared short SQLStatisticsW(void* hstmt, ushort* szCatalogName, short cchCatalogName, ushort* szSchemaName, short cchSchemaName, ushort* szTableName, short cchTableName, ushort fUnique, ushort fAccuracy);
	__gshared short SQLTablesW(void* hstmt, ushort* szCatalogName, short cchCatalogName, ushort* szSchemaName, short cchSchemaName, ushort* szTableName, short cchTableName, ushort* szTableType, short cchTableType);
	__gshared short SQLDataSourcesW(void* henv, ushort fDirection, ushort* szDSN, short cchDSNMax, short* pcchDSN, ushort* wszDescription, short cchDescriptionMax, short* pcchDescription);

	string ODBCDriverConnect(ODBCHandle connectionHandle, void* hwnd, string connectionString, ushort fDriverCompletion) @trusted {
        if (connectionHandle.handleType != SQL_HANDLE_DBC) {
            throw new ODBCException("Invalid handle provided. Please provide a valid Connection handle.");
        }
        auto wcs = connectionString.toUTF16;
        wchar[2048] connStrOutput;
        short connStrOutputLen;
        ODBCThrowOnError(SQLDriverConnectW(connectionHandle.handle, hwnd, cast(wchar*)wcs.toUTF16z, cast(short)wcs.length, connStrOutput.ptr, cast(short)2048, &connStrOutputLen, fDriverCompletion), connectionHandle, "The following errors occured while attempting to open the connection:");
        return to!string(connStrOutput[0..connStrOutputLen]);
    }

	__gshared short SQLBrowseConnectW(void* hdbc, ushort* szConnStrIn, short cchConnStrIn, ushort* szConnStrOut, short cchConnStrOutMax, short* pcchConnStrOut);
	__gshared short SQLColumnPrivilegesW(void* hstmt, ushort* szCatalogName, short cchCatalogName, ushort* szSchemaName, short cchSchemaName, ushort* szTableName, short cchTableName, ushort* szColumnName, short cchColumnName);
	__gshared short SQLGetStmtAttrW(void* hstmt, int fAttribute, void* rgbValue, int cbValueMax, int* pcbValue);
	__gshared short SQLSetStmtAttrW(void* hstmt, int fAttribute, void* rgbValue, int cbValueMax);
	__gshared short SQLForeignKeysW(void* hstmt, ushort* szPkCatalogName, short cchPkCatalogName, ushort* szPkSchemaName, short cchPkSchemaName, ushort* szPkTableName, short cchPkTableName, ushort* szFkCatalogName, short cchFkCatalogName, ushort* szFkSchemaName, short cchFkSchemaName, ushort* szFkTableName, short cchFkTableName);
	__gshared short SQLNativeSqlW(void* hdbc, ushort* szSqlStrIn, int cchSqlStrIn, ushort* szSqlStr, int cchSqlStrMax, int* pcchSqlStr);
	__gshared short SQLPrimaryKeysW(void* hstmt, ushort* szCatalogName, short cchCatalogName, ushort* szSchemaName, short cchSchemaName, ushort* szTableName, short cchTableName);
	__gshared short SQLProcedureColumnsW(void* hstmt, ushort* szCatalogName, short cchCatalogName, ushort* szSchemaName, short cchSchemaName, ushort* szProcName, short cchProcName, ushort* szColumnName, short cchColumnName);
	__gshared short SQLProceduresW(void* hstmt, ushort* szCatalogName, short cchCatalogName, ushort* szSchemaName, short cchSchemaName, ushort* szProcName, short cchProcName);
	__gshared short SQLTablePrivilegesW(void* hstmt, ushort* szCatalogName, short cchCatalogName, ushort* szSchemaName, short cchSchemaName, ushort* szTableName, short cchTableName);
	__gshared short SQLDriversW(void* henv, ushort fDirection, ushort* szDriverDesc, short cchDriverDescMax, short* pcchDriverDesc, ushort* szDriverAttributes, short cchDrvrAttrMax, short* pcchDrvrAttr);

private:
	void ODBCThrowOnError(short result, ODBCHandle handle, string message) @trusted {
		message = newline ~ message;
		if (result == SQL_ERROR || result == SQL_INVALID_HANDLE) {
			short recordCount = 0;
			SQLGetDiagFieldW(handle.handleType, handle.handle, cast(short)0, cast(short)SQL_DIAG_NUMBER, cast(void*)&recordCount, cast(short)0, null);

			int nativeError;
			short msgLen;
			short i = 1;
			wchar[SQL_MAX_MESSAGE_LENGTH] msg;
			wchar[6] sqlState;
			while (i <= recordCount && SQLGetDiagRecW(handle.handleType, handle.handle, i, sqlState.ptr, &nativeError, msg.ptr, cast(short)SQL_MAX_MESSAGE_LENGTH, &msgLen) != SQL_NO_DATA) {
				i++;
				message ~= newline ~ "\t" ~ to!string(nativeError) ~ "\t" ~ to!string(fromStringz(sqlState)) ~ "\t" ~ to!string(fromStringz(msg));
			}
			throw new ODBCException(message);
		}

		return;
	}
