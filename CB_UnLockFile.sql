SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CB_UnLockFile] @cbFile sysname, @cbType smallint AS 
BEGIN
    SET NOCOUNT ON;
    IF (@cbType IS NULL OR @cbType NOT IN (0,1,2,3)) BEGIN
        RAISERROR(80007,11,1);
		RETURN;
    END;

    DELETE TOP(1) FROM cbLock WHERE cbSPID = @@SPID AND cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbType = @cbType AND cbMarq = -1;
    IF (@@ROWCOUNT = 0) BEGIN
        RAISERROR(80000,11,1);
		RETURN;
    END;
END;
GO