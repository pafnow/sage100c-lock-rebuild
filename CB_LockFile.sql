SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CB_LockFile] @cbFile sysname, @cbType smallint AS 
BEGIN
    SET NOCOUNT ON;
    IF (@cbType IS NULL OR @cbType NOT IN (0,1,2,3)) BEGIN
        RAISERROR(80007,11,1);
		RETURN;
    END;

    --Exclusive Lock
    --Cannot create FileLock 1 if a FileLock 1 exists
    IF (@cbType = 1 AND EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbType = @cbType AND cbMarq = -1 AND cbSPID <> @@SPID)) BEGIN
        RAISERROR(80008,11,1);
		RETURN;
    END;
    --Cannot create FileLock 3 if RecordLock 3 or 4 exists
    IF (@cbType = 3 AND EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbType IN (3,4) AND cbMarq >= 0 AND cbSPID <> @@SPID)) BEGIN
        RAISERROR(80004,11,1);
		RETURN;
    END;

    INSERT INTO cbLock(cbSPID,cbDb,cbFile,cbType,cbMarq) VALUES (@@SPID,IsNull(DB_ID(),0),IsNull(OBJECT_ID(@cbFile),0),@cbType,-1);
    --//TODO: return error code if cannot insert lock
END;
GO