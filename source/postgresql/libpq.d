module std.experimental.database.sql.postgresql.libpq;

import core.stdc.stdio;

extern (C):

alias PG_INT64_TYPE = long;

alias Oid = uint;
enum OID_MAX = uint.max;
enum InvalidOid = cast(Oid)0;

alias pg_int64 = PG_INT64_TYPE;

enum PG_DIAG_SEVERITY = 'S';
enum PG_DIAG_SEVERITY_NONLOCALIZED = 'V';
enum PG_DIAG_SQLSTATE = 'C';
enum PG_DIAG_MESSAGE_PRIMARY = 'M';
enum PG_DIAG_MESSAGE_DETAIL = 'D';
enum PG_DIAG_MESSAGE_HINT = 'H';
enum PG_DIAG_STATEMENT_POSITION = 'P';
enum PG_DIAG_INTERNAL_POSITION = 'p';
enum PG_DIAG_INTERNAL_QUERY = 'q';
enum PG_DIAG_CONTEXT = 'W';
enum PG_DIAG_SCHEMA_NAME = 's';
enum PG_DIAG_TABLE_NAME = 't';
enum PG_DIAG_COLUMN_NAME = 'c';
enum PG_DIAG_DATATYPE_NAME = 'd';
enum PG_DIAG_CONSTRAINT_NAME = 'n';
enum PG_DIAG_SOURCE_FILE = 'F';
enum PG_DIAG_SOURCE_LINE = 'L';
enum PG_DIAG_SOURCE_FUNCTION = 'R';

enum PG_COPYRES_ATTRS = 0x01;
enum PG_COPYRES_TUPLES = 0x02;
enum PG_COPYRES_EVENTS = 0x04;
enum PG_COPYRES_NOTICEHOOKS = 0x08;

enum ConnStatusType
{
	CONNECTION_OK,
	CONNECTION_BAD,
	CONNECTION_STARTED,
	CONNECTION_MADE,
	CONNECTION_AWAITING_RESPONSE,
	CONNECTION_AUTH_OK,
	CONNECTION_SETENV,
	CONNECTION_SSL_STARTUP,
	CONNECTION_NEEDED
}

enum PostgresPollingStatusType
{
	PGRES_POLLING_FAILED = 0,
	PGRES_POLLING_READING,
	PGRES_POLLING_WRITING,
	PGRES_POLLING_OK,
	PGRES_POLLING_ACTIVE
}

enum ExecStatusType
{
	PGRES_EMPTY_QUERY = 0,
	PGRES_COMMAND_OK,
	PGRES_TUPLES_OK,
	PGRES_COPY_OUT,
	PGRES_COPY_IN,
	PGRES_BAD_RESPONSE,
	PGRES_NONFATAL_ERROR,
	PGRES_FATAL_ERROR,
	PGRES_COPY_BOTH,
	PGRES_SINGLE_TUPLE
}

enum PGTransactionStatusType
{
	PQTRANS_IDLE,
	PQTRANS_ACTIVE,
	PQTRANS_INTRANS,
	PQTRANS_INERROR,
	PQTRANS_UNKNOWN
}

enum PGVerbosity
{
	PQERRORS_TERSE,
	PQERRORS_DEFAULT,
	PQERRORS_VERBOSE
}

enum PGContextVisibility
{
	PQSHOW_CONTEXT_NEVER,
	PQSHOW_CONTEXT_ERRORS,
	PQSHOW_CONTEXT_ALWAYS
}

enum PGPing
{
	PQPING_OK,
	PQPING_REJECT,
	PQPING_NO_RESPONSE,
	PQPING_NO_ATTEMPT
}

struct pg_conn;
alias PGconn = pg_conn;

struct pg_result;
alias PGresult = pg_result;

struct pg_cancel;
alias PGcancel = pg_cancel;

struct pgNotify
{
	char	   *relname;
	int			be_pid;
	char	   *extra;
	pgNotify   *next;
}
alias PGnotify = pgNotify;

alias PQnoticeReceiver = void function (void *arg, const PGresult *res);
alias PQnoticeProcessor = void function (void *arg, const char *message);

alias pqbool = char;

struct _PQprintOpt
{
	pqbool		header;
	pqbool		align_;
	pqbool		standard;
	pqbool		html3;
	pqbool		expanded;
	pqbool		pager;
	char	   *fieldSep;
	char	   *tableOpt;
	char	   *caption;
	char	  **fieldName;
}
alias PQprintOpt = _PQprintOpt;

struct _PQconninfoOption
{
	char	   *keyword;
	char	   *envvar;
	char	   *compiled;
	char	   *val;
	char	   *label;
	char	   *dispchar;
	int			dispsize;
}
alias PQconninfoOption = _PQconninfoOption;

struct PQArgBlock
{
	int			len;
	int			isint;
	union u
	{
		int		*ptr;
		int		integer;
	}
}

struct pgresAttDesc
{
	char	   *name;
	Oid			tableid;
	int			columnid;
	int			format;
	Oid			typid;
	int			typlen;
	int			atttypmod;
}
alias PGresAttDesc = pgresAttDesc;

PGconn *PQconnectStart(const char *conninfo);
PGconn *PQconnectStartParams(const char * keywords, const char * values, int expand_dbname);
PostgresPollingStatusType PQconnectPoll(PGconn *conn);

PGconn *PQconnectdb(const char *conninfo);
PGconn *PQconnectdbParams(const char * keywords, const char * values, int expand_dbname);
PGconn *PQsetdbLogin(const char *pghost, const char *pgport, const char *pgoptions, const char *pgtty, const char *dbName, const char *login, const char *pwd);

void PQfinish(PGconn *conn);

PQconninfoOption *PQconndefaults();

PQconninfoOption *PQconninfoParse(const char *conninfo, char **errmsg);

PQconninfoOption *PQconninfo(PGconn *conn);

void PQconninfoFree(PQconninfoOption *connOptions);

int PQresetStart(PGconn *conn);
PostgresPollingStatusType PQresetPoll(PGconn *conn);

void PQreset(PGconn *conn);

PGcancel *PQgetCancel(PGconn *conn);

void PQfreeCancel(PGcancel *cancel);

int	PQcancel(PGcancel *cancel, char *errbuf, int errbufsize);

int	PQrequestCancel(PGconn *conn);

char *PQdb(const PGconn *conn);
char *PQuser(const PGconn *conn);
char *PQpass(const PGconn *conn);
char *PQhost(const PGconn *conn);
char *PQport(const PGconn *conn);
char *PQtty(const PGconn *conn);
char *PQoptions(const PGconn *conn);
ConnStatusType PQstatus(const PGconn *conn);
PGTransactionStatusType PQtransactionStatus(const PGconn *conn);
char *PQparameterStatus(const PGconn *conn, const char *paramName);
int	PQprotocolVersion(const PGconn *conn);
int	PQserverVersion(const PGconn *conn);
char *PQerrorMessage(const PGconn *conn);
int	PQsocket(const PGconn *conn);
int	PQbackendPID(const PGconn *conn);
int	PQconnectionNeedsPassword(const PGconn *conn);
int	PQconnectionUsedPassword(const PGconn *conn);
int	PQclientEncoding(const PGconn *conn);
int	PQsetClientEncoding(PGconn *conn, const char *encoding);

int PQsslInUse(PGconn *conn);
void *PQsslStruct(PGconn *conn, const char *struct_name);
char *PQsslAttribute(PGconn *conn, const char *attribute_name);
char * PQsslAttributeNames(PGconn *conn);

void *PQgetssl(PGconn *conn);

void PQinitSSL(int do_init);

void PQinitOpenSSL(int do_ssl, int do_crypto);

PGVerbosity PQsetErrorVerbosity(PGconn *conn, PGVerbosity verbosity);

PGContextVisibility PQsetErrorContextVisibility(PGconn *conn, PGContextVisibility show_context);

void PQtrace(PGconn *conn, FILE *debug_port);
void PQuntrace(PGconn *conn);

PQnoticeReceiver PQsetNoticeReceiver(PGconn *conn, PQnoticeReceiver proc, void *arg);
PQnoticeProcessor PQsetNoticeProcessor(PGconn *conn, PQnoticeProcessor proc, void *arg);

alias pgthreadlock_t = void function (int acquire);
pgthreadlock_t PQregisterThreadLock(pgthreadlock_t newhandler);

PGresult *PQexec(PGconn *conn, const char *query);
PGresult *PQexecParams(PGconn *conn,
			 const char *command,
			 int nParams,
			 const Oid *paramTypes,
			 const char * paramValues,
			 const int *paramLengths,
			 const int *paramFormats,
			 int resultFormat);
PGresult *PQprepare(PGconn *conn, const char *stmtName,
		  const char *query, int nParams,
		  const Oid *paramTypes);
PGresult *PQexecPrepared(PGconn *conn,
			   const char *stmtName,
			   int nParams,
			   const char * paramValues,
			   const int *paramLengths,
			   const int *paramFormats,
			   int resultFormat);

int	PQsendQuery(PGconn *conn, const char *query);
int PQsendQueryParams(PGconn *conn,
				  const char *command,
				  int nParams,
				  const Oid *paramTypes,
				  const char *paramValues,
				  const int *paramLengths,
				  const int *paramFormats,
				  int resultFormat);
int PQsendPrepare(PGconn *conn, const char *stmtName,
			  const char *query, int nParams,
			  const Oid *paramTypes);
int PQsendQueryPrepared(PGconn *conn,
					const char *stmtName,
					int nParams,
					const char * paramValues,
					const int *paramLengths,
					const int *paramFormats,
					int resultFormat);
int	PQsetSingleRowMode(PGconn *conn);
PGresult *PQgetResult(PGconn *conn);

int	PQisBusy(PGconn *conn);
int	PQconsumeInput(PGconn *conn);

PGnotify *PQnotifies(PGconn *conn);

int	PQputCopyData(PGconn *conn, const char *buffer, int nbytes);
int	PQputCopyEnd(PGconn *conn, const char *errormsg);
int	PQgetCopyData(PGconn *conn, char **buffer, int async);

int	PQgetline(PGconn *conn, char *string, int length);
int	PQputline(PGconn *conn, const char *string);
int	PQgetlineAsync(PGconn *conn, char *buffer, int bufsize);
int	PQputnbytes(PGconn *conn, const char *buffer, int nbytes);
int	PQendcopy(PGconn *conn);

int	PQsetnonblocking(PGconn *conn, int arg);
int	PQisnonblocking(const PGconn *conn);
int	PQisthreadsafe();
PGPing PQping(const char *conninfo);
PGPing PQpingParams(const char * keywords,
			 const char * values, int expand_dbname);

int	PQflush(PGconn *conn);

PGresult *PQfn(PGconn *conn,
	 int fnid,
	 int *result_buf,
	 int *result_len,
	 int result_is_int,
	 const PQArgBlock *args,
	 int nargs);

ExecStatusType PQresultStatus(const PGresult *res);
char *PQresStatus(ExecStatusType status);
char *PQresultErrorMessage(const PGresult *res);
char *PQresultVerboseErrorMessage(const PGresult *res,
							PGVerbosity verbosity,
							PGContextVisibility show_context);
char *PQresultErrorField(const PGresult *res, int fieldcode);
int	PQntuples(const PGresult *res);
int	PQnfields(const PGresult *res);
int	PQbinaryTuples(const PGresult *res);
char *PQfname(const PGresult *res, int field_num);
int	PQfnumber(const PGresult *res, const char *field_name);
Oid	PQftable(const PGresult *res, int field_num);
int	PQftablecol(const PGresult *res, int field_num);
int	PQfformat(const PGresult *res, int field_num);
Oid	PQftype(const PGresult *res, int field_num);
int	PQfsize(const PGresult *res, int field_num);
int	PQfmod(const PGresult *res, int field_num);
char *PQcmdStatus(PGresult *res);
char *PQoidStatus(const PGresult *res);
Oid	PQoidValue(const PGresult *res);
char *PQcmdTuples(PGresult *res);
char *PQgetvalue(const PGresult *res, int tup_num, int field_num);
int	PQgetlength(const PGresult *res, int tup_num, int field_num);
int	PQgetisnull(const PGresult *res, int tup_num, int field_num);
int	PQnparams(const PGresult *res);
Oid	PQparamtype(const PGresult *res, int param_num);

PGresult *PQdescribePrepared(PGconn *conn, const char *stmt);
PGresult *PQdescribePortal(PGconn *conn, const char *portal);
int	PQsendDescribePrepared(PGconn *conn, const char *stmt);
int	PQsendDescribePortal(PGconn *conn, const char *portal);

void PQclear(PGresult *res);

void PQfreemem(void *ptr);

PGresult *PQmakeEmptyPGresult(PGconn *conn, ExecStatusType status);
PGresult *PQcopyResult(const PGresult *src, int flags);
int	PQsetResultAttrs(PGresult *res, int numAttributes, PGresAttDesc *attDescs);
void *PQresultAlloc(PGresult *res, size_t nBytes);
int	PQsetvalue(PGresult *res, int tup_num, int field_num, char *value, int len);

size_t PQescapeStringConn(PGconn *conn,
				   char *to, const char *from, size_t length,
				   int *error);
char *PQescapeLiteral(PGconn *conn, const char *str, size_t len);
char *PQescapeIdentifier(PGconn *conn, const char *str, size_t len);
ubyte *PQescapeByteaConn(PGconn *conn,
				  const ubyte *from, size_t from_length,
				  size_t *to_length);
ubyte *PQunescapeBytea(const ubyte *strtext,
				size_t *retbuflen);

void PQprint(FILE *fout,
		const PGresult *res,
		const PQprintOpt *ps);

int	lo_open(PGconn *conn, Oid lobjId, int mode);
int	lo_close(PGconn *conn, int fd);
int	lo_read(PGconn *conn, int fd, char *buf, size_t len);
int	lo_write(PGconn *conn, int fd, const char *buf, size_t len);
int	lo_lseek(PGconn *conn, int fd, int offset, int whence);
pg_int64 lo_lseek64(PGconn *conn, int fd, pg_int64 offset, int whence);
Oid	lo_creat(PGconn *conn, int mode);
Oid	lo_create(PGconn *conn, Oid lobjId);
int	lo_tell(PGconn *conn, int fd);
pg_int64 lo_tell64(PGconn *conn, int fd);
int	lo_truncate(PGconn *conn, int fd, size_t len);
int	lo_truncate64(PGconn *conn, int fd, pg_int64 len);
int	lo_unlink(PGconn *conn, Oid lobjId);
Oid	lo_import(PGconn *conn, const char *filename);
Oid	lo_import_with_oid(PGconn *conn, const char *filename, Oid lobjId);
int	lo_export(PGconn *conn, Oid lobjId, const char *filename);

int	PQlibVersion();

int	PQmblen(const char *s, int encoding);

int	PQdsplen(const char *s, int encoding);

int	PQenv2encoding();

char *PQencryptPassword(const char *passwd, const char *user);

int	pg_char_to_encoding(const char *name);
char *pg_encoding_to_char(int encoding);
int	pg_valid_server_encoding_id(int encoding);
