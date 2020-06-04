SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CB_IsRecordLock] @cbFile sysname, @cbMarq as int, @lRes int OUTPUT AS 
BEGIN
    IF EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbMarq = IsNull(@cbMarq,0)) BEGIN
        SET @lRes = 1;
    END ELSE BEGIN
        SET @lRes = 0;
    END;
END;
GO