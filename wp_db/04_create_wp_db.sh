#!/bin/bash
cat <<EOF
███████╗████████╗███████╗██████╗     ██╗  ██╗
██╔════╝╚══██╔══╝██╔════╝██╔══██╗    ██║  ██║
███████╗   ██║   █████╗  ██████╔╝    ███████║
╚════██║   ██║   ██╔══╝  ██╔═══╝     ╚════██║
███████║   ██║   ███████╗██║              ██║
╚══════╝   ╚═╝   ╚══════╝╚═╝              ╚═╝
EOF

set -e
exec > >(tee -a 04_ssl.log) 2>&1
echo
echo "=== Installing mod_ssl and creating a directory for the key and certificate =="
sudo dnf install mod_ssl -y
sudo mkdir -p /etc/httpd/ssl
echo

echo "=== SSL Certificate Configuration ==="

#prompt for SSL cert details
read -p "Country code (e.g., US): " country
read -p "State (e.g., NY): " state
read -p "City (e.g., Brookhaven): " city
read -p "Organization (e.g., IT): " org
read -p "Common Name (e.g., example.com): " cn

subject="/C=$country/ST=$state/L=$city/O=$org/CN=$cn"

echo "=== Creating self-signed certificate ==="
sudo openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
  -keyout /etc/httpd/ssl/wordpress.key \
  -out /etc/httpd/ssl/wordpress.crt \
  -subj "$subject"
echo

echo "=== Securing SSL keys to only allow Root user access ==="
sudo chmod 600 /etc/httpd/ssl
sudo systemctl restart httpd
echo
echo "=== SSL configuration complete ==="
echo
echo "=== Cert created for $cn ==="
echo

echo "=== Configure WordPress to connect to the database ==="
read -p "Enter WordPress database name here: " DatabaseName
read -p "Enter WordPress database user Created in Part 2" DatabaseUser
read -s -p "Enter that same users password" DatabasePassword

sudo -u apache sed -i "s/{$DatabaseName}/wordpress/" /www/var/html/wordpress/wp-config.php
sudo -u apache sed -i "s/{$DatabaseUser}/wordpress/" /www/var/html/wordpress/wp-config.php
sudo -u apache sed -i "s/{$DatabasePassword}/wordpress/" /www/var/html/wordpress/wp-config.php
echo

cat <<EOF
Next you would want to add something like the following inside of your /etc/httpd/conf.d/wordpress.conf :
--------------------------------------------------
<VirtualHost *:80>
    ServerName vegapunk.strawhats.local
    DocumentRoot /var/www/html/wordpress/
    Redirect / https://vegapunk.strawhats.local/
</VirtualHost>

<VirtualHost *:443>
    ServerName vegapunk.strawhats.local
    DocumentRoot /var/www/html/wordpress/
    SSLEngine on
    SSLCertificateFile /etc/httpd/ssl/wordpress.crt
    SSLCertificateKeyFile /etc/httpd/ssl/wordpress.key

    <Directory "/var/www/html/wordpress">
			Options FollowSymlinks
      AllowOverride All
      Require all granted
    </Directory>
    #This line only allows localhost to reach the wp admin and login pages
		<FilesMatch "wp-(admin|login)\.php">
		Require local
		</FilesMatch>
    ErrorLog /var/log/httpd/wordpress_error.log
</VirtualHost>
--------------------------------------------------
and then add the following WITH YOUR CONFIGURATIONS: 
sudo nano /var/www/html/wordpress/wp-config.php

#Add these just before the line "/* That's all, stop editing! */":
define('WP_HOME', 'https://vegapunk.strawhats.local');
define('WP_SITEURL', 'https://vegapunk.strawhats.local');

#Next add the Keys,Salt,and Auth defines in the same configuration file
define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );
EOF 
exit 0

