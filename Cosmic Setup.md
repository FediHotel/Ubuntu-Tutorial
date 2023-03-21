Install Ubuntu 22.04 Server with ssh enabled

# Install Cosmic and LiteSpeed with Dependencies 
Run this one by one !
```shell
apt-get install build-essential libexpat1-dev libgeoip-dev libpcre3-dev zlib1g-dev libssl-dev libxml2-dev rcs libpng-dev -y
```
```shell
apt install software-properties-common && sudo add-apt-repository ppa:ondrej/php
```
```shell
apt-get install software-properties-common dirmngr apt-transport-https
```
```shell
apt-get install npm -y
curl -sL https://deb.nodesource.com/setup_19.x | sudo -E bash -
apt install nodejs -y
```

## Install Default PHP 8.1
```shell
apt-get install php8.1 php8.1-common php8.1-curl php8.1-mysql php8.1-opcache php8.1-imap -y
```
```shel
apt install php8.1-xml php8.1-xmlrpc php8.1-gd php8.1-imagick php8.1-cli php8.1-dev php8.1-imap php8.1-mbstring php8.1-soap php8.1-zip php8.1-intl unzip -y
```
```shell
apt-get remove apache2 -y
apt-get autoremove -y
```

## Install MariaDB
```shell
apt install mariadb-server -y
```

## Install http Litespeed

```shell
cd /tmp
wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debian_repo.sh | sudo bash
apt-get install openlitespeed -y
```
```shell
apt install lsphp81 lsphp81-mysql lsphp81-common lsphp81-opcache lsphp81-curl
```
```systemctl start lsws```

To verify the webserver : 
```systemctl status lsws```
```text
lshttpd.service - OpenLiteSpeed HTTP Server
     Loaded: loaded (/etc/systemd/system/lshttpd.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2022-03-26 07:25:03 UTC; 49s ago

```
### Configure Admin username and password

```shell
bash /usr/local/lsws/admin/misc/admpass.sh
```
```text

Please specify the user name of administrator.
This is the user name required to login the administration Web interface.

User name [admin]: 

Please specify the administrator's password.
This is the password required to login the administration Web interface.

Password: 
Retype password: 
Administrator's username/password is updated successfully!
```

## Access the Litespeed backend and change default web port

https://1.2.3.4:7080  ## Where 1.2.3.4 is your ip / hostname
-> goto Listners in the right side menu  
-> Click on the view glass on the right of the cell  
-> select edit in the Address Settings right of the bar
-> change the default port from 8088 to 80  
-> select the restart button on the top right of the screen

Edit the server config file:
```shell
vi /usr/local/lsws/conf/httpd_config.conf
```

Replace:
```ini
lsphp74/bin/lsphp
```
With
```ini 
lsphp81/bin/lsphp
```
to save type ":wq!"   <-- no quotes
```shell
systemctl restart lsws
```
Test the PHP version, go to http://1.2.3.4/phpinfo.php <-- Change the IP to your IP.

### Cosmic Dependencies install
```shell
apt install php8.1-xml php8.1-xmlrpc php8.1-gd php8.1-imagick php8.1-cli php8.1-dev php8.1-imap php8.1-mbstring php8.1-soap php8.1-zip php8.1-intl unzip -y
```

### Composer install

```shell
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
sudo php /tmp/composer-setup.php --install-dir=/usr/bin --filename=composer
```

### Cosmic CMS install

```shell
mkdir /var/www/retrohotel
mkdir /var/www/retrohotel/CMS
git clone https://git.camwijs.eu/duckietm/Cosmic-CMS.git /var/www/retrohotel/CMS
cd /var/www/retrohotel/CMS
composer install
```

### Cosmic Database install and also Arcturus DB with catalog

```shell
mysql_secure_installation
```
```text
Enter current password for root (enter for none):
OK, successfully used password, moving on...

Switch to unix_socket authentication [Y/n] n
 ... skipping.

Change the root password? [Y/n] Y
New password: *******
Re-enter new password: *******
Password updated successfully!
Reloading privilege tables..
 ... Success!

Remove anonymous users? [Y/n] Y
 ... Success!

Disallow root login remotely? [Y/n] Y
 ... Done.

Remove test database and access to it? [Y/n] Y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reload privilege tables now? [Y/n] Y
 ... Success!

Thanks for using MariaDB!
```
When you want to access your database from an other location other then localhost do the following:
```shell
vi /etc/mysql/mariadb.conf.d/50-server.cnf
```
Edit the : ```bind-address  127.0.0.1``` and change this to ```0.0.0.0```  
```shell
service mariadb restart
```

Import the database with a WorkBench (HeidiSQL / Navicat / SQL Workbench etc. etc.)

Default Arcturus Database : https://git.krews.org/morningstar/ms4-base-database/-/archive/ms4/ms4-base-database-ms4.zip

Cosmic Database           : https://git.camwijs.eu/duckietm/Cosmic-CMS/src/branch/main/Setup/SQL/Setup.sql


```shell
mkdir /var/www/retrohotel/CMS/public/uploads
chown -R nobody:nogroup /var/www/retrohotel/CMS/public/uploads/
cd /var/www/retrohotel/CMS
vi .env  <--- Edit settings to set to your DB
```
```ini
DB_DRIVER=mysql
DB_HOST=localhost
DB_NAME=MyDBName
DB_USER=DBUSER
DB_PASS=DBUserPAssword
DB_CHARSET=utf8
DB_COLLATION=collation
```
to save type ":wq!"   <-- no quotes"

```shell
vi /var/www/retrohotel/CMS/src/App/Config.php <-- Edit the Cosmic settings 
``` 
```ini
"nitro_path"                  => "http(s)://####YOUR URL####/client",

"domain"      => "## YOUR DOMAIN NAME ## expl. : habbohotel.com",
"fpath"       => "http(s)://####YOUR URL####/imaging",
"shortname"   => "Retrohotel",
"sitename"    => "Retrohotel",
"cpath"       => "http(s)://####YOUR URL####/gamedata",
```

### Setup Cosmic in LiteSpeed

Open an browser and goto : https://1.2.3.4:7080 <-- Login with you LiteSpeed credentials.  
Navigate to the Virtual Hosts, this in the leftside menu bar.  
In the sumary you will see the Default virtuel host, in action select the delete virtual host.  
At the right top you must now select the restart.

When you go to http://1.2.3.4 you should recive an 404 error, as we deleted the main web site.

Navigate to the Virtual Hosts, this in the leftside menu bar.  
Press the + in the Virtual Host List bar.  

In the next screen we will setup the Virtual server, make the following changes:
```
Virtual Host Name      : retrohotel <-- Or you Hotel Name
Virtual Host Root      : /var/www/retrohotel/CMS <-- This is the Virtual Host root and not the Document root
Config File            : $SERVER_ROOT/conf/vhosts/$VH_NAME/vhconf.conf
Enable Scripts/ExtApps : Yes
Restrained             : Yes
```
Press Save at the top of the screen (This is in the Virtual Host Bar shown as an flopy disk).  
you will get the following error : Input error detected. Please resolve the error(s).
go to Config File and select the : file /usr/local/lsws/conf/vhosts/retrohotel.conf does not exist. CLICK TO CREATE  
Save again and the Virtual host has been created.

You are back at the Virtual host screen, now press View on the Virtual host (this is the magnify glass)  
Goto the General Tab of the Virtual Host and select Edit on the right side onf the General settings.

Change the Document root to :``` $VH_ROOT/public ``` and Save


--> Goto the Log Tab of the Virtual Host and select Edit on the right side:
```
Use Server's Log     : NO
File Name            : /var/log/RetroHotel_VirtualHost.log
Log Level            : Error
Rolling Size (bytes) : 100M
Keep Days            : 14
Compress Archive     : Compress Archive
Press Save at the top of the screen 
```
--> Goto the Log Tab of the Virtual Host and select Add on the right side from the Access Log (This is in the same screen)
```
Log Control          : Own log file
File Name            : /var/log/RetroHotel_AccessLog.log
Rolling Size (bytes) : 100M
Keep Days            : 14
Compress Archive     : Yes
```
Press Save at the top of the screen

--> Goto the Rewrite Tab of the Virtual Host and select Rewrite Control edit
```
Enable Rewrite           : Yes
Auto Load from .htaccess : Yes
```
Press Save at the top of the screen  

Navigate to the Listners, this in the leftside menu bar and edit the Default listner
At the bottom Virtual Host Mappings press + to assign the Virtual host

```text
Virtual Host : retrohotel
Domains      : *
```
Press Save at the top of the screen  
Now goto shell and reboot the Machine, after the reboot goto http://1.2.3.4 and Cosmic has been compleetly setup.
