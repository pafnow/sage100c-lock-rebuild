SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CB_LockVrac] @cbFile sysname AS 
BEGIN
    SET NOCOUNT ON;

    --Exclusive Lock
    IF (EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbType = -1 AND cbMarq = -1 AND cbSPID <> @@SPID)) BEGIN
        RAISERROR(80001,11,1);
		RETURN;
    END;

    INSERT INTO cbLock(cbSPID,cbDb,cbFile,cbType,cbMarq) VALUES (@@SPID,IsNull(DB_ID(),0),IsNull(OBJECT_ID(@cbFile),0),-1,-1);
    --//TODO: return error code if cannot insert lock
END;
GO