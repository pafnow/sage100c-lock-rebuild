SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CB_UnLockRecord] @cbFile sysname, @cbType smallint, @cbMarq int AS 
BEGIN
    SET NOCOUNT ON;
    IF (@cbType IS NULL OR @cbType NOT IN (3,4)) BEGIN
        RAISERROR(80007,11,1);
		RETURN;
    END;

    DELETE TOP(1) FROM cbLock WHERE cbSPID = @@SPID AND cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbType = @cbType AND cbMarq = IsNull(@cbMarq,0);
    IF (@@ROWCOUNT = 0) BEGIN
        RAISERROR(80000,11,1);
		RETURN;
    END;
END;
GO