# sage100c-lock-rebuild
Rebuilding the lock system of Sage 100cloud to get rid of cbsqlxp.dll

### Improvements //TODO
* Global lock disable checking based on session variable
* In-Memory Table for better performance
* Natively compiled stored procedures for better performance?

### Alternatives
* Modify stored procedures in master database
=> Problem when calling non-extended stored procedures from functions (error)