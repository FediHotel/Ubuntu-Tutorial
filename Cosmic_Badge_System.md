# Cosmic Badges buy and badge's general

Before continue make sure you have the CMS installed and verify that it is running  

This will allow you to buy badges from the CMS (Draw your own badge) and will setup the groupbadges  
```shell
mkdir /var/www/retrohotel/Gamedata/c_images
mkdir /var/www/retrohotel/Gamedata/c_images/album1584
```
place all the default bagdes in : /var/www/retrohotel/Gamedata/c_images/album1584  
If you do not have any use the https://git.krews.org/duckietm/converter here you can download all the default badges  

 ```shell
 chown -R nobody:nogroup /var/www/retrohotel/Gamedata/c_images/album1584
 ```
```mysql
mariadb
USE #YOURDB#;
UPDATE website_settings SET value='/var/www/retrohotel/Gamedata/c_images/album1584/' WHERE `key`='draw_badge_imaging';
exit
```
This setting can be tested if the Emulator is running and the Webkit plugin is installed in the Emulator

## Groups Badges

```git
git clone https://git.krews.org/skeletor/group-badge-imager.git /tmp/groupbadge
```
```shell
cd /tmp/groupbadge
cp -r habbo-imaging/ /var/www/retrohotel/CMS/public/
mkdir /var/www/retrohotel/CMS/public/habbo-imaging/badgeparts/cache
chown -R nobody:nogroup /var/www/retrohotel/CMS/public/habbo-imaging/badgeparts/cache
```
And that is all folks !  
You can test the groupbadge : http://###YOUR DOMAIN or IP###/habbo-imaging/badge/b017114s202098s201106s187092s202100

