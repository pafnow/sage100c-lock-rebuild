SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CB_IsVracLock] @cbFile sysname, @lRes int OUTPUT AS 
BEGIN
	DECLARE
		@lBase int,
		@lTable int,
		@lErr int;

	SET NOCOUNT ON;
	SET @lBase = DB_ID();
	SET @lTable = OBJECT_ID(@cbFile);
	EXECUTE @lErr = master..xp_CBIsVracLock @@SPID,@lBase,@lTable,@lRes OUTPUT;
	IF @lErr <> 0
	BEGIN
		RAISERROR(@lErr,11,1);
		RETURN;
	END;
END;
GO
GRANT EXECUTE ON [dbo].[CB_IsVracLock] TO [public] AS [dbo]
GO
