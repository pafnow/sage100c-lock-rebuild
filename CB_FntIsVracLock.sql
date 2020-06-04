SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[CB_FntIsVracLock](@cbFile sysname) RETURNS int AS 
BEGIN
    IF (SESSION_CONTEXT(N'cbLockDisable') = 1) RETURN 0;

    IF EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbType = -1 AND cbMarq = -1 AND cbSPID <> @@SPID) BEGIN
        RETURN 1
    END;
    
    RETURN 0;
END;
