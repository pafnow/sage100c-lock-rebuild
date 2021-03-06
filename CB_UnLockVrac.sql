SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CB_UnLockVrac] @cbFile sysname AS 
BEGIN
    SET NOCOUNT ON;

    DELETE TOP(1) FROM cbLock WHERE cbSPID = @@SPID AND cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbType = -1 AND cbMarq = -1;
    IF (@@ROWCOUNT = 0) BEGIN
        RAISERROR(80000,11,1);
		RETURN;
    END;
END;
GO