SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CB_PurgeLock] WITH EXECUTE AS 'USER_CBASE' AS
BEGIN
	SET NOCOUNT ON;
	UPDATE cbSysTable SET CB_Mono = cbUserSession.cbOldMode FROM cbUserSession WHERE (cbSession = @@SPID OR cbSession NOT IN (SELECT session_id FROM sys.dm_exec_sessions WHERE DB_NAME(database_id)=DB_NAME())) AND cbSysTable.CB_Type = cbUserSession.CB_Type AND cbLockBase > 0;
	UPDATE cbUserSession SET cbLockBase = 0 WHERE cbSession = @@SPID OR cbSession NOT IN (SELECT session_id FROM sys.dm_exec_sessions WHERE DB_NAME(database_id)=DB_NAME());
	
    --Remove locks of current SPID
    DELETE FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbSPID = @@SPID;
    --Remove orphamn locks, where SPID is not active anymore
    DELETE FROM cbLock WHERE cbDb = IsNull(DB_ID(),0) AND cbSPID NOT IN (SELECT session_id FROM sys.dm_exec_sessions WHERE DB_NAME(database_id)=DB_NAME());
END;
GO