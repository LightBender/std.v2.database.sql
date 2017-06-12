module std.experimental.database.sql.transaction;

struct SqlTransaction {
    ISqlTransaction ctx;

    @disable this(this);

    this(ISqlTransaction ctx) {
        this.ctx = ctx;
        ctx.start(this);
     }

    ~this() {
        ctx.finish(this);
    }

    void commit() { ctx.commit(this); }
    void rollBack() { ctx.rollBack(this); }
}

interface ISqlTransaction {
    void start(ref Transaction);
    void finish(ref Transaction);

	void commit(ref Transaction);
	void rollBack(ref Transaction);
}