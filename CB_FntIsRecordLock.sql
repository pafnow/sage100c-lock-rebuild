SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[CB_FntIsRecordLock](@cbFile sysname, @cbMarq as int) RETURNS int AS 
BEGIN
    IF (SESSION_CONTEXT(N'cbLockDisable') = 1) RETURN 0;

    IF EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbMarq = IsNull(@cbMarq,0) AND cbSPID <> @@SPID) BEGIN
        RETURN 1
    END;

    RETURN 0;
END;
