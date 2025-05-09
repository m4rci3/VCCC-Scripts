import subprocess
import datetime 

def backup_sql():
	date = datetime.datetime.now().strftime("%Y%m%d+%H%M%S")
	backup_file = f"/var/backsups/deebee_{date}.sql"

	with open(backup_file, "w") as f:
		subprocess.run(["mysqldump", "wordpress_db"], stdout=f)

backup_sql()
