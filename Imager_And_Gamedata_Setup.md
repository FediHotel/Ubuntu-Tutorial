# Setup the Nitro Imager, this will render all the avatars from your reposotory  
Before continue make sure you have the CMS installed and verify that it is running  

## Setup the Imager
```shell
mkdir /var/www/retrohotel/Gamedata
git clone https://git.krews.org/nitro/nitro-imager.git /var/www/retrohotel/Imager
mkdir /var/www/retrohotel/Imager/saved_figure
```
```shell
vi /var/www/retrohotel/Imager/src/app/router/HttpRouter.ts
````
Replace:  
```HttpRouter.use('/', HabboImagingRouter);```  
With:  
```HttpRouter.use('/imaging', HabboImagingRouter);```  
to save type ":wq!"   <-- no quotes

# Setup Gamedata  

We now need to get all the gamedata setup, for this we need .nitro files and .json file's  
You can transfer all your gamedata for your own recourse or download them with the Downloader tool and also add the Nitro default assets  
- Downloader tool : https://git.krews.org/duckietm/converter
- Nitro default assets : https://git.krews.org/nitro/default-assets  

After done downloading / converting etc. etc.  
We need for the Imager to work the following folders with the files in /var/www/retrohotel/Gamedata  (Please be aware the Linux is case sensitive so don't mistake with captials or no capitals)  

```shell
mkdir /var/www/retrohotel/Gamedata/effect
mkdir /var/www/retrohotel/Gamedata/clothes
mkdir /var/www/retrohotel/Gamedata/config
```

* effect <-- C:\Tools\Convert\assets\bundled\effect
* clothes <-- C:\Tools\Convert\assets\bundled\figure
* config  <-- C:\Tools\Convert\assets\gamedata
* config  <-- https://git.krews.org/nitro/default-assets/-/tree/master/gamedata/HabboAvatarActions.json (Copy this file in this dir)  

You can use WINSCP or any other tool that can transfer files to the Linux server  

```shell
cd /var/www/retrohotel/Imager
vi tsconfig.json
```
Alter the config in the following:

```text
    "api.host": "localhost",
    "api.port": 3030,
    "asset.url": "https://Your_URL",
    "gamedata.url": "/var/www/retrohotel/Gamedata",
    "avatar.save.path": "/var/www/retrohotel/Imager/saved_figure",
    "avatar.actions.url": "/var/www/retrohotel/Gamedata/config/HabboAvatarActions.json",
    "avatar.figuredata.url": "/var/www/retrohotel/Gamedata/config/FigureData.json",
    "avatar.figuremap.url": "/var/www/retrohotel/Gamedata/config/FigureMap.json",
    "avatar.effectmap.url": "/var/www/retrohotel/Gamedata/config/EffectMap.json",
    "avatar.asset.url": "/var/www/retrohotel/Gamedata/clothes/%libname%.nitro",
    "avatar.asset.effect.url": "/var/www/retrohotel/Gamedata/effect/%libname%.nitro",
```
```shell
mkdir /var/www/retrohotel/Imager/saved_figure
npm run build
```
Now we will test the Imager by starting with : ```npm run start```  
If all went fine you should see the following output  
```
 [Nitro] [AssetManager] Downloading: /var/www/retrohotel/Gamedata/clothes/hh_human_body.nitro +138ms
 [Nitro] [AssetManager] Downloading: /var/www/retrohotel/Gamedata/clothes/hh_human_item.nitro +48ms
 [Nitro] [AssetManager] Downloading: /var/www/retrohotel/Gamedata/effect/Dance1.nitro +190ms
 [Nitro] [AssetManager] Downloading: /var/www/retrohotel/Gamedata/effect/Dance2.nitro +3ms
 [Nitro] [AssetManager] Downloading: /var/www/retrohotel/Gamedata/effect/Dance3.nitro +1ms
 [Nitro] [AssetManager] Downloading: /var/www/retrohotel/Gamedata/effect/Dance4.nitro +1ms
 [Nitro] [Application] Initialized +4ms
 [Nitro] [Application] Server Started localhost:3030 +2ms
```

# Setup the Webproxy

Login to : https://1.2.3.4:7080/ where 1.2.3.4 is your IP / hostname  
Navigate to Server Configuration and select External App in the Top navigation.  
In the External Applications bar press + to add the proxy server.  
By Type select : Web Server and press next in the New External App bar  
```text
Name                           : Imager
Address                        : http://localhost:3030
Max Connections                : 250
Connection Keep-Alive Timeout  : 10
Initial Request Timeout (secs) : 10
Retry Timeout (secs)           : 10
```
In the  Web Server bar press save.  
Navigate to Virtual Hosts and edit the retrohotel  
In the Virtual Host top menu bar goto Context and press the + in the Context List bar  
Select Type : Proxy and press next in the New Context bar  
```text
URI : /imaging/
Webserver : Select Imager
```
Press save in the Proxy Context Definition bar  
Now press the gracefull restart button to make the proxy active  
You can test it out : http://#YOUR URL or IP#/imaging/?figure=hr-890-37.hd-605-8.ch-650-76.lg-715-76.sh-907-71.he-3274-71.fa-3276-1408.ca-1812.wa-2008&direction=2  
You do need to start the service by : ```npm run start``` in the Imager directory, press CTRL+C when the test is done.  
When you see the avatar you are ready to go to the next step :)

# Make the imager to run as an service

```shell
npm install pm2@latest -g
```
```shell
pm2 start /var/www/retrohotel/Imager/dist/index.js
```
You will see the following output :
```text
┌─────┬──────────┬─────────────┬─────────┬─────────┬──────────┬────────┬──────┬───────────┬──────────┬──────────┬──────────┬──────────┐
│ id  │ name     │ namespace   │ version │ mode    │ pid      │ uptime │ ↺    │ status    │ cpu      │ mem      │ user     │ watching │
├─────┼──────────┼─────────────┼─────────┼─────────┼──────────┼────────┼──────┼───────────┼──────────┼──────────┼──────────┼──────────┤
│ 0   │ index    │ default     │ 1.0.0   │ fork    │ 18878    │ 0s     │ 0    │ online    │ 0%       │ 32.3mb   │ root     │ disabled │
└─────┴──────────┴─────────────┴─────────┴─────────┴──────────┴────────┴──────┴───────────┴──────────┴──────────┴──────────┴──────────┘
```
```shell
pm2 startup systemd
```
```shell
pm2 save
```
```shell
systemctl start pm2-root.service
```
```shell
systemctl status pm2-root.service
```
```txt
Mar 28 09:57:08 yourhost pm2[19075]: [PM2] PM2 Successfully daemonized
Mar 28 09:57:08 yourhost pm2[19075]: [PM2] Resurrecting
Mar 28 09:57:08 yourhost pm2[19075]: [PM2] Restoring processes located in /root/.pm2/dump.pm2
Mar 28 09:57:08 yourhost pm2[19075]: [PM2] Process /var/www/retrohotel/Imager/dist/index.js restored
Mar 28 09:57:09 yourhost pm2[19075]: ┌─────┬──────────┬─────────────┬─────────┬─────────┬──────────┬────────┬──────┬───────────┬──────────┬──────────┬──────────┬──────────┐
Mar 28 09:57:09 yourhost pm2[19075]: │ id  │ name     │ namespace   │ version │ mode    │ pid      │ uptime │ ↺    │ status    │ cpu      │ mem      │ user     │ watching │
Mar 28 09:57:09 yourhost pm2[19075]: ├─────┼──────────┼─────────────┼─────────┼─────────┼──────────┼────────┼──────┼───────────┼──────────┼──────────┼──────────┼──────────┤
Mar 28 09:57:09 yourhost pm2[19075]: │ 0   │ index    │ default     │ 1.0.0   │ fork    │ 19111    │ 0s     │ 0    │ online    │ 0%       │ 31.7mb   │ root     │ disabled │
Mar 28 09:57:09 yourhost pm2[19075]: └─────┴──────────┴─────────────┴─────────┴─────────┴──────────┴────────┴──────┴───────────┴──────────┴──────────┴──────────┴──────────┘
Mar 28 09:57:09 yourhost systemd[1]: Started PM2 process manager.
```
Now reboot you machine to test the service, and after the reboot run the following :
```pm2 status```
```text
┌─────┬──────────┬─────────────┬─────────┬─────────┬──────────┬────────┬──────┬───────────┬──────────┬──────────┬──────────┬──────────┐
│ id  │ name     │ namespace   │ version │ mode    │ pid      │ uptime │ ↺    │ status    │ cpu      │ mem      │ user     │ watching │
├─────┼──────────┼─────────────┼─────────┼─────────┼──────────┼────────┼──────┼───────────┼──────────┼──────────┼──────────┼──────────┤
│ 0   │ index    │ default     │ 1.0.0   │ fork    │ 1047     │ 7s     │ 0    │ online    │ 0%       │ 121.6mb  │ root     │ disabled │
└─────┴──────────┴─────────────┴─────────┴─────────┴──────────┴────────┴──────┴───────────┴──────────┴──────────┴──────────┴──────────┘
```
This means the service is online and up & running, so you can test the url again to make sure.  

```shell
vi /var/www/retrohotel/CMS/src/App/Config.php
```
Change the following to use your own Imager
```text
      "domain"      => "http://###Your Domain or IP###",
      "cpath"       => "http://###Your Domain or IP###/assets",
      "fpath"       => "http://###Your Domain or IP###/imaging",
      "shortname"   => "Cosmic Test",
      "sitename"    => "Cosmic Test"
```
And we now have a fully functional auto starting Imager !!! 
