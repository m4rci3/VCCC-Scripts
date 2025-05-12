#!/bin/bash
cat <<EOF
           ____             __     __ __     _____           _       __
          / __ \____ ______/ /_   / // /    / ___/__________(_)___  / /_
         / /_/ / __  / ___/ __/  / // /_    \__ \/ ___/ ___/ / __ \/ __/
        / ____/ /_/ / /  / /_   /__  __/   ___/ / /__/ /  / / /_/ / /_
       /_/    \__,_/_/   \__/     /_/     /____/\___/_/  /_/ .___/\__/
                                                          /_/
EOF

set -e
exec > >(tee -a 04_ssl.log) 2>&1
echo "=== Installing mod_ssl ==="
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
echo "=== Apache service restarted ====" 
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

#add these just before the line "/* That's all, stop editing! */":
define('WP_HOME', 'https://vegapunk.strawhats.local');
define('WP_SITEURL', 'https://vegapunk.strawhats.local');

#Define database details in the same config file (wp-config.php)
#The DatabaseName , DatabaseUser, DatabasePassword, and DatabaseHost

#At a certain point you will also get to the security keys portion
#here there's a link to a website where you get randsom salts and keys 
#that you use to substitute the defaults inside of the config file 
#"makes your site harder to succesfully attack by adding random elements to the password"
EOF

