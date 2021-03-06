SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CB_FntIsRecordLock](@cbFile sysname, @cbMarq as int) RETURNS int AS 
BEGIN
	DECLARE
		@lBase int,
		@lTable int,
		@lRes int;

	SET @lBase = DB_ID();
	SET @lTable = OBJECT_ID(@cbFile);
	EXECUTE master..xp_CBIsRecordLock @@SPID,@lBase,@lTable,@cbMarq,@lRes OUTPUT;
	RETURN @lRes;
END;
GO
GRANT EXECUTE ON [dbo].[CB_FntIsRecordLock] TO [public] AS [dbo]
GO
