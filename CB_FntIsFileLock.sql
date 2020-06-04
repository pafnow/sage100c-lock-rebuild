SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[CB_FntIsFileLock](@cbFile sysname, @cbType smallint) RETURNS int AS 
BEGIN
    IF (@cbType IS NULL OR @cbType NOT IN (0,1,2,3)) RETURN NULL; --Error 80007

    IF EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbType = @cbType AND cbMarq = -1) BEGIN
        RETURN 1;
    END;

    RETURN 0;
END;
GO