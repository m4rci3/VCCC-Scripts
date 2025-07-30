# Do this before using the script inside of your environment

In order for a script like this to function as intended we would want to set it on a schedule. For Unix-like systems we would set a cronjob to handle it or for MS/Windows systems, we would use Task Scheduler. If we go with the former we set sufficient credentials inside of the following: `/etc/.my.cnf` OR `~/.my.cnf` as such:
```ascii
▄▄███▄▄·
██╔════╝
███████╗
╚════██║
███████║███████╗
╚═▀▀▀══╝╚══════╝
[mysqldump]
user=username
password=password
```
This path, if set as such, will be the credentials taken for executing `mysqldump`, allowing your cronjob to run automatically without the need for manual password input or embedding the credentials into the script itself. Additionally it is highly advised for the user to restrict this file to be read-only by root (`chmod 600 /etc/.my.cnf`), minimizing the risk of unauthorized access.
