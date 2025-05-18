## Script Descriptions
These are scripts I made for NCyTE's VCCC. 

wp_db contains a 4 part script used to build and configure a WordPress `LAMP` stack (Linux, Apache, MariaDB, and PHP), these scripts are made for RPM-based distros like RHEL, Rocky, Alma,CentOS 

```mermaid
flowchart LR;
    subgraph  
        dnf-Updates/Upgrades
        Firewalld-->HTTPS/443
        Firewalld-->HTTP/80
        Permissions-->Apache
        Hostname-change
        Hardening-->mysql_secure_installation
        Hardening-->localhost-only-wp-admin
         WP-Database+WPAdmin--creation for-->MariaDB

    end
    subgraph  
        Apache
        WordPress
        PHP
        mod_ssl --configure SSL for HTTPS --> Apache
        MariaDB -- connection to --> WordPress

    end
```    

db_dump contains a single script used to take a sql or mariadb database and dump its contents, additional details to have this script work properly are inside of the script's directory.

```mermaid
flowchart LR;
    subgraph  
        Database-->Backup-Directory;
    end
```

---
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Bash Script](https://img.shields.io/badge/bash_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)
![WordPress](https://img.shields.io/badge/WordPress-%23117AC9.svg?style=for-the-badge&logo=WordPress&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Apache](https://img.shields.io/badge/apache-%23D42029.svg?style=for-the-badge&logo=apache&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white)
![PHP](https://img.shields.io/badge/php-%23777BB4.svg?style=for-the-badge&logo=php&logoColor=white)
![Red Hat](https://img.shields.io/badge/Red%20Hat-EE0000?style=for-the-badge&logo=redhat&logoColor=white)
