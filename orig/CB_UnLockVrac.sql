SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CB_UnLockVrac] @cbFile sysname AS 
BEGIN
	DECLARE
		@lBase int,
		@lTable int,
		@lRes int;

	SET NOCOUNT ON;
	SET @lBase = DB_ID();
	SET @lTable = OBJECT_ID(@cbFile);
	EXECUTE @lRes = master..xp_CBUnLockVrac @@SPID,@lBase,@lTable;
	IF @lRes <> 0
	BEGIN
		RAISERROR(@lRes,11,1);
		RETURN;
	END;
END;
GO
GRANT EXECUTE ON [dbo].[CB_UnLockVrac] TO [public] AS [dbo]
GO
