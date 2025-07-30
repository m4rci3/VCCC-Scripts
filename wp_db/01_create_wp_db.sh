#!/bin/bash
cat <<EOF
███████╗████████╗███████╗██████╗      ██╗    
██╔════╝╚══██╔══╝██╔════╝██╔══██╗    ███║    
███████╗   ██║   █████╗  ██████╔╝    ╚██║    
╚════██║   ██║   ██╔══╝  ██╔═══╝      ██║    
███████║   ██║   ███████╗██║          ██║    
╚══════╝   ╚═╝   ╚══════╝╚═╝          ╚═╝    
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

echo "=== Let's confirm Apache is running properly on port 80 ==="
sudo ss -tulpn | grep :80
echo "=== There should be an output of *:80 ==="
echo

echo "=== Adding HTTP & HTTPS to firewall rules and changing default zone to public ==="
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --set-default-zone=public
sudo firewall-cmd --permanent --add-service=http --zone=public
sudo firewall-cmd --permanent --add-service=https --zone=public
sudo firewall-cmd --reload
sudo firewall-cmd --list-services --zone=public
echo

echo "=== Installing MariaDB ==="
sudo yum install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl status mariadb
echo

echo "=== Running the mysql_secure_installation script, follow onscreen instructions ==="
sudo mysql_secure_installation

cat <<EOF
After which you need to run the next command if you are hosting your Wordpress & or Apache
sudo nano /etc/my.cnf.d/mariadb-server.cnf -> bind address = 0.0.0.0 
== Next run ./02_create_wp_db.sh ==  
EOF
exit 0
