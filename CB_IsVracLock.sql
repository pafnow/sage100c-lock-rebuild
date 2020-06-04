SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CB_IsVracLock] @cbFile sysname, @lRes int OUTPUT AS 
BEGIN
    IF EXISTS(SELECT 1 FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbFile = IsNull(OBJECT_ID(@cbFile),0) AND cbType = -1 AND cbMarq = -1) BEGIN
        SET @lRes = 1;
    END ELSE BEGIN
        SET @lRes = 0;
    END;
END;
GO