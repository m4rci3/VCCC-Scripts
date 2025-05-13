#!/bin/bash
cat <<EOF
             ____             __     ___   _____           _       __
            / __ \____ ______/ /_   <  /  / ___/__________(_)___  / /_
           / /_/ / __  / ___/ __/   / /   \__ \/ ___/ ___/ / __ \/ __/
          / ____/ /_/ / /  / /_    / /   ___/ / /__/ /  / / /_/ / /_
         /_/    \__,_/_/   \__/   /_/   /____/\___/_/  /_/ .___/\__/
                                                        /_/
EOF

# Redirect output to log file
exec > >(tee -a script.log) 2>&1

# Exit on error
set -e

echo "=== Running package update and upgrade ==="
sudo dnf update -y
sudo dnf upgrade -y

echo
echo "=== Installing and enabling Apache ==="
sudo dnf install -y httpd
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo systemctl status httpd.service
echo

echo "=== Let's set the hostname of this device ==="
read -p "Enter the desired hostname: " hostname
sudo hostnamectl set-hostname "$hostname"
echo "=== Your hostname is now $hostname. Open a new terminal to see the change. ==="
echo
# Confirm Apache is listening on port 80
echo "=== Let's confirm Apache is running properly on port 80 ==="
sudo ss -tulpn | grep :80
echo "=== There should be an output of *:80 ==="
echo
# Configure firewall
echo "=== Adding HTTP & HTTPS to firewall rules and changing default zone to public ==="
udo firewall-cmd --set-default-zone=public
sudo firewall-cmd --permanent --add-service=http --zone=public
sudo firewall-cmd --permanent --add-service=https --zone=public
sudo firewall-cmd --reload
sudo firewall-cmd --list-services --zone=public

# Install MariaDB
echo "=== Installing Mariadb ==="
sudo yum install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl status mariadb

# Run secure installation
echo
echo "=== Run the following command manually to secure MariaDB ==="
echo "sudo mysql_secure_installation"
echo
echo "After which you need to run the next command if you are hosting your website on a seperate machine from your databate"
echo "or you want another or multple hosts to connect to the database" 
echo "sudo nano /etc/my.cnf.d/mariadb-server.cnf "
echo "bind address = 0.0.0.0" 
echo
echo "After completing that, run ./02_create_wp_db.sh" 
exit 0

