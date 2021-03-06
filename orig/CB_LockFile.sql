SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CB_LockFile] @cbFile sysname, @cbType smallint AS 
BEGIN
	DECLARE 
		@lBase int,
		@lTable int,
		@lRes int;

	SET NOCOUNT ON;
	SET @lBase = DB_ID();
	SET @lTable = OBJECT_ID(@cbFile);
	EXECUTE @lRes = master..xp_CBLockFile @@SPID,@lBase,@lTable,@cbType;
	IF @lRes <> 0
	BEGIN
		RAISERROR(@lRes,11,1);
		RETURN;
	END;
END;
GO
GRANT EXECUTE ON [dbo].[CB_LockFile] TO [public] AS [dbo]
GO
