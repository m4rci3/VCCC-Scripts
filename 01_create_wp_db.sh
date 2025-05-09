#!/bin/bash
cat << "EOF"
     ____             __     ___                  _       __
   / __ \____ ______/ /_   <  /  _______________(_)___  / /_
  / /_/ / __ `/ ___/ __/   / /  / ___/ ___/ ___/ / __ \/ __/
 / ____/ /_/ / /  / /_    / /  (__  ) /__/ /  / / /_/ / /_
/_/    \__,_/_/   \__/   /_/  /____/\___/_/  /_/ .___/\__/
                                              /_/
EOF 
#!/bin/bash
# Redirect output to log file
exec > >(tee -a script.log) 2>&1

# Exit on error
set -e

# System update
sudo dnf update -y
sudo dnf upgrade -y

# Install Apache
sudo dnf install -y httpd
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo systemctl status httpd.service

# Set hostname
read -p "Enter the desired hostname: " hostname
sudo hostnamectl set-hostname "$hostname"
echo "Your hostname is now $hostname. Open a new terminal to see the change."

# Confirm Apache is listening on port 80
sudo ss -tulpn | grep :80
echo "There should be an output of *:80"

# Configure firewall
echo "Adding HTTP & HTTPS to firewall rules for the public zone."
sudo firewall-cmd --permanent --add-service=http --zone=public
sudo firewall-cmd --permanent --add-service=https --zone=public
sudo firewall-cmd --reload
sudo firewall-cmd --list-services --zone=public

# Install MariaDB
sudo yum install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl status mariadb

# Run secure installation 
echo "Run the following command manually to secure MariaDB:"
echo "sudo mysql_secure_installation"
echo "After completing that , run ./02_create_wp_db.sh" 
exit 0


