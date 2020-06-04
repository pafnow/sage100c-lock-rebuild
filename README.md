# sage100c-lock-rebuild
Rebuilding the lock system of Sage 100cloud to get rid of cbsqlxp.dll

### Installation
Just execute all the sql files in the root of this repository to create needed table and overwrite related stored procedures and functions.

### Usage
Please refer to the Sage documentation for details on its usage.

A feature has been added to allow bypass of lock checking (useful when doing some mass updates on the database via SQL Direct). To use it, just setup a session context variable as below:
```sql
EXEC sys.sp_set_session_context @key = N'cbLockDisable', @value = 1;
```

### Improvements //TODO
* In-Memory Table for better performance
* Natively compiled stored procedures for better performance?

### Alternatives
* Modify stored procedures in master database
=> Problem when calling non-extended stored procedures from functions (error)
