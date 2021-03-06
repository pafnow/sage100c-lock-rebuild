SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CB_PurgeLock] WITH EXECUTE AS 'USER_CBASE' AS
BEGIN
	DECLARE
		@lRes int,
		@lBase int,
		@cbSession int;
	DECLARE c_Session CURSOR LOCAL FOR SELECT cbSession FROM cbUserSession WHERE cbSession = @@SPID OR cbSession NOT IN (SELECT session_id FROM sys.dm_exec_sessions WHERE DB_NAME(database_id)=DB_NAME());

	SET NOCOUNT ON;
	UPDATE cbSysTable SET CB_Mono = cbUserSession.cbOldMode FROM cbUserSession WHERE (cbSession = @@SPID OR cbSession NOT IN (SELECT session_id FROM sys.dm_exec_sessions WHERE DB_NAME(database_id)=DB_NAME())) AND cbSysTable.CB_Type = cbUserSession.CB_Type AND cbLockBase > 0;
	UPDATE cbUserSession SET cbLockBase = 0 WHERE cbSession = @@SPID OR cbSession NOT IN (SELECT session_id FROM sys.dm_exec_sessions WHERE DB_NAME(database_id)=DB_NAME());
    SET @lBase = DB_ID();
	EXECUTE @lRes = master..xp_CBPurgeLock @@SPID,@lBase;
	IF @lRes <> 0
	BEGIN
		RAISERROR(@lRes,11,1);
		RETURN;
	END;
	OPEN c_Session;
	FETCH NEXT FROM c_Session INTO @cbSession;
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		EXECUTE @lRes = master..xp_CBPurgeLock @cbSession,@lBase;
		IF @lRes <> 0
		BEGIN
			RAISERROR(@lRes,11,1);
			RETURN;
		END;
		FETCH NEXT FROM c_Session INTO @cbSession;
	END;
	CLOSE c_Session;
	DEALLOCATE c_Session;
END;
GO
GRANT EXECUTE ON [dbo].[CB_PurgeLock] TO [public] AS [dbo]
GO
