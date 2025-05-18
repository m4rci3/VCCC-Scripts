#!/bin/bash
cat <<EOF
            ____             __     ___      _____           _       __
           / __ \____ ______/ /_   |__ \    / ___/__________(_)___  / /_
          / /_/ / __  / ___/ __/   __/ /    \__ \/ ___/ ___/ / __ \/ __/
         / ____/ /_/ / /  / /_    / __/    ___/ / /__/ /  / / /_/ / /_
        /_/    \__,_/_/   \__/   /____/   /____/\___/_/  /_/ .___/\__/
                                                          /_/
EOF

set -e
exec > >(tee -a 02_db_setup.log) 2>&1

echo "== Setting up WordPress Database =="
read -s -p "Enter the MariaDB root password: " dbrootpass
read -p "Enter name for new WordPress database: " wp_db
read -p "Enter username for new WordPress database user: " wp_user
read -s -p "Enter password for new WordPress database user: " wp_pass
mysql -u root -p"$dbrootpass" <<EOF
CREATE DATABASE $wp_db;
CREATE USER '$wp_user'@'localhost' IDENTIFIED BY '$wp_pass';
GRANT ALL PRIVILEGES ON $wp_db.* TO '$wp_user'@'localhost';
FLUSH PRIVILEGES;
EOF
echo

cat <<EOF
Created database:      $wp_d<D-s>b
Created user:          $wp_user
{$wp_user} only has localhost privileges, if needed change this line to a '%' or however you need in the script
Password (hidden):     [REDACTED]
"== Database setup complete. Now run ./03_setup_php_wordpress.sh =="
EOF
exit 0
