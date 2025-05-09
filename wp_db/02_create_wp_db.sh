#!/bin/bash
cat << "EOF"
    ____             __     ___                     _       __
   / __ \____ ______/ /_   |__ \    _______________(_)___  / /_
  / /_/ / __ `/ ___/ __/   __/ /   / ___/ ___/ ___/ / __ \/ __/
 / ____/ /_/ / /  / /_    / __/   (__  ) /__/ /  / / /_/ / /_
/_/    \__,_/_/   \__/   /____/  /____/\___/_/  /_/ .___/\__/
                                                 /_/
EOF

set -e
exec > >(tee -a 02_db_setup.log) 2>&1

# Prompt for DB root password
read -s -p "Enter the MariaDB root password: " dbrootpass
echo

# Prompt for new WordPress DB, user, and password
read -p "Enter name for new WordPress database: " wp_db
read -p "Enter username for WordPress database user: " wp_user
read -s -p "Enter password for WordPress database user: " wp_pass

# Create DB and user
mysql -u root -p"$dbrootpass" <<EOF
CREATE DATABASE $wp_db;
CREATE USER '$wp_user'@'localhost' IDENTIFIED BY '$wp_pass';
GRANT ALL PRIVILEGES ON $wp_db.* TO '$wp_user'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "Database setup complete."
echo "Created database:      $wp_db"
echo "Created user:          $wp_user"
echo "Password (hidden):     [REDACTED]"
echo "Database setup complete. Now run ./03_setup_php_wordpress.sh"
