SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CB_IsFileLock] @cbFile sysname, @cbType smallint, @lRes int OUTPUT AS 
BEGIN
    IF (@cbType IS NULL OR @cbType NOT IN (0,1,2,3)) BEGIN
        RAISERROR(80007,11,1);
		RETURN;
    END;

    IF      (SESSION_CONTEXT(N'cbLockBypass') = 1) --Bypass all locks
    BEGIN
        SET @lRes = 0;
    END 
    ELSE IF (SESSION_CONTEXT(N'cbLockBypass') = 2  --Bypass own locks only
         AND NOT EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbType = @cbType AND cbMarq = -1 AND SystemUser <> SUSER_NAME()))
    BEGIN
        SET @lRes = 0;
    END
    ELSE IF (NOT EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbType = @cbType AND cbMarq = -1 AND cbSPID <> @@SPID))
    BEGIN
        SET @lRes = 0;
    END
    ELSE
    BEGIN
        SET @lRes = 1;
    END;
END;