#!/bin/bash
cat <<EOF
            ____             __     _____    _____           _       __
           / __ \____ ______/ /_   |__  /   / ___/__________(_)___  / /_
          / /_/ / __  / ___/ __/    /_ <    \__ \/ ___/ ___/ / __ \/ __/
         / ____/ /_/ / /  / /_    ___/ /   ___/ / /__/ /  / / /_/ / /_
        /_/    \__,_/_/   \__/   /____/   /____/\___/_/  /_/ .___/\__/
                                                          /_/
EOF

set -e
exec > >(tee -a 03_php_wp.log) 2>&1

echo "=== Installing EPEL and Remi repositories for the latest PHP installs of RHEL 9==="
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm --skip-broken && sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm --skip-broken
echo

echo "=== Resetting php and enabling the newest version of the install as of the creation of this script ==="
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

echo "=== WordPress files are in place at /var/www/html. Run ./04_configure_ssl.sh to secure your site. ==="
echo
php -v 
echo
echo "=== To make sure (if needed) that you have the latest version of php run: ===" 
echo "sudo dnf module list php"

