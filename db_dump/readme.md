#Do this before using the script inside of your environment 

With a script like this you would want to have it run either every day or how ever you desire, so we would want to set it with a cronjob and in order for it to run automatically without needing input, we set sufficent credentials inside of thefollowing: /etc/.my.cnf OR ~/.my.cnf as such: 
 
```bash
[mysqldump]
user=username
password=password
```
