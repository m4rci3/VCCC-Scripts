#!/bin/bash
cat <<EOF
███████╗████████╗███████╗██████╗     ██████╗ 
██╔════╝╚══██╔══╝██╔════╝██╔══██╗    ╚════██╗
███████╗   ██║   █████╗  ██████╔╝     █████╔╝
╚════██║   ██║   ██╔══╝  ██╔═══╝      ╚═══██╗
███████║   ██║   ███████╗██║         ██████╔╝
╚══════╝   ╚═╝   ╚══════╝╚═╝         ╚═════╝ 
EOF

set -e
exec > >(tee -a 03_php_wp.log) 2>&1

echo "=== Installing EPEL and Remi repositories for the latest PHP installs for RHEL 9 ==="
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm --skip-broken && sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm --skip-broken
echo

echo "===  Initializing PHP ==="
sudo dnf module reset php -y
sudo dnf module enable php:remi-8.4
sudo dnf install -y php php-mysqlnd php-mbstring php-opcache php-gd php-xml php-curl php-common php-json
echo

echo "=== Downloading WordPress ==="
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
echo

echo "=== Copying wordpress to /var/www/html and allowing Apache to read these files (permissions) ==="
sudo cp -r wordpress /var/www/html/
sudo chown -R apache:apache /var/www/html
sudo chmod -R 750 /var/www/html
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

echo "=== WordPress files are in place at /var/www/html and PHP is configured. Run ./04_create_wp_db.sh ==="
echo
php -v
exit 0
