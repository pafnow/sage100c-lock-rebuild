SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[CB_FntIsRecordLock](@cbFile sysname, @cbMarq as int) RETURNS int AS 
BEGIN
    IF      (SESSION_CONTEXT(N'cbLockBypass') = 1) --Bypass all locks
    BEGIN
        RETURN 0;
    END 
    ELSE IF (SESSION_CONTEXT(N'cbLockBypass') = 2  --Bypass own locks only
         AND NOT EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbMarq = IsNull(@cbMarq,0) AND SystemUser <> SUSER_NAME()))
    BEGIN
        RETURN 0;
    END
    ELSE IF (NOT EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbMarq = IsNull(@cbMarq,0) AND cbSPID <> @@SPID))
    BEGIN
        RETURN 0;
    END;
    
    RETURN 1;
END;