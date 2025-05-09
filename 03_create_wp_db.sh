#!/bin/bash
cat << "EOF"
    ____             __     _____                   _       __
   / __ \____ ______/ /_   |__  /   _______________(_)___  / /_
  / /_/ / __ `/ ___/ __/    /_ <   / ___/ ___/ ___/ / __ \/ __/
 / ____/ /_/ / /  / /_    ___/ /  (__  ) /__/ /  / / /_/ / /_
/_/    \__,_/_/   \__/   /____/  /____/\___/_/  /_/ .___/\__/
                                                 /_/

EOF
#!/bin/bash
set -e
exec > >(tee -a 03_php_wp.log) 2>&1

echo "== Installing EPEL and Remi repositories for the latest PHP installs =="
sudo dnf install -y \
  https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
  https://rpms.remirepo.net/enterprise/remi-release-8.rpm

sudo dnf module reset php -y
sudo dnf module enable -y php:remi-8.2
sudo dnf install -y php php-mysqlnd php-mbstring php-opcache php-gd php-xml php-curl php-common php-json

php -v

echo "== Downloading WordPress =="
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/
sudo chown -R apache:apache /var/www/html
sudo chmod -R 750 /var/www/html

echo "WordPress files are in place at /var/www/html. Run ./04_configure_ssl.sh to secure your site."
