SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CB_LockRecord] @cbFile sysname, @cbType smallint, @cbMarq int AS 
BEGIN
    SET NOCOUNT ON;
    IF (@cbType IS NULL OR @cbType NOT IN (3,4)) BEGIN
        RAISERROR(80007,11,1);
		RETURN;
    END;

    --Exclusive Lock
    --Cannot create RecordLock 3 or 4 if a RecordLock 3 exists + cannot create RecordLock 3 if RecordLock 4 exists
    --Only can create RecordLock 4 if RecordLock 4 exists
    IF (EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND (cbType = 3 OR @cbType = 3) AND cbMarq = IsNull(@cbMarq,0) AND cbSPID <> @@SPID)) BEGIN
        RAISERROR(80003,11,1);
		RETURN;
    END;
    --Cannot create RecordLock 3 or 4 if FileLock 3 exists
    IF (@cbType IN (3,4) AND EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbType = 3 AND cbMarq = -1 AND cbSPID <> @@SPID)) BEGIN
        RAISERROR(80003,11,1);
		RETURN;
    END;

    INSERT INTO cbLock(cbSPID,cbDb,cbFile,cbType,cbMarq) VALUES (@@SPID,IsNull(DB_ID(),0),IsNull(OBJECT_ID(@cbFile),0),@cbType,IsNull(@cbMarq,0));
    --//TODO: return error code if cannot insert lock
END;
GO