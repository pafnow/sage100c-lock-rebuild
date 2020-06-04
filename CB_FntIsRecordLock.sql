SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[CB_FntIsRecordLock](@cbFile sysname, @cbMarq as int) RETURNS int AS 
BEGIN
    IF EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbMarq = IsNull(@cbMarq,0)) BEGIN
        RETURN 1
    END;

    RETURN 0;
END;
GO