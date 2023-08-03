# Setup the Nitro Imager, this will render all the avatars from your reposotory  
Before continue make sure you have the CMS installed and verify that it is running  

## Nitro Imager with Node V19

Copy the content to example : /docker/nitro_imager

Change the /docker/nitro_imager/.env

Let say your content is (clothes & config) in :/var/www/XXX/XXX/XXX then change the path in the .env file
But if you host your CMS on a other server you can replace the absoulte path with url paths as well.

Example :
```env
API_HOST=imager
API_PORT=3030
AVATAR_SAVE_PATH=/src/saved_figure
AVATAR_ACTIONS_URL=/var/www/Gamedata/config/HabboAvatarActions.json
AVATAR_FIGUREDATA_URL=/var/www/Gamedata/config/FigureData.json
AVATAR_FIGUREMAP_URL=/var/www/Gamedata/config/FigureMap.json
AVATAR_EFFECTMAP_URL=/var/Gamedata/config/EffectMap.json
AVATAR_ASSET_URL=/var/www/Gamedata/clothes/%libname%.nitro
```
Next make the path avalibe in /docker/nitro_imager/docker-compose.yml

Example:

```yml
services:
  nodejs:
    container_name: imager
    build:
      context: ./
      target: imager
    volumes:
      - ./imager:/src
      - /var/www:/var/www # Path to your data
    command: sh -c "npm run start" # Change this after the first startup of the docker !
    tty: true
```

Now you can run : docker-compose up -d 

and this will build and make the imager avalible on port 3030

to use it use the following in nginx:

```
location /imaging/ {
        proxy_pass http://172.38.0.2:3030;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
```

* Don't forget your firewall not to allow access from outside.
* if you have nginx setup and the docker is running, you can test it by using the follwing URL : https://##YOUR DOMAIN##/imaging/?figure=ha-1003-88.lg-285-89.ch-3032-1334-109.sh-3016-110.hd-180-1359.ca-3225-110-62.wa-3264-62-62.hr-891-1342.0;action=std&gesture=sml&direction=2&head_direction=2amp;img_format=png&gesture=srp&headonly=1&size=l

# Setup the Webproxy
To be continued

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