SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CB_FntIsFileLock](@cbFile sysname, @cbType smallint) RETURNS int AS 
BEGIN
	DECLARE
		@lBase int,
		@lTable int,
		@lRes int;

	SET @lBase = DB_ID();
	SET @lTable = OBJECT_ID(@cbFile);
	EXECUTE master..xp_CBIsFileLock @@SPID,@lBase,@lTable,@cbType,@lRes OUTPUT;
	RETURN @lRes;
END;
GO
GRANT EXECUTE ON [dbo].[CB_FntIsFileLock] TO [public] AS [dbo]
GO
