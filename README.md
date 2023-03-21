# Install Ubuntu 22.04 Server with Cosmic / Arcturus / Nitro Client and Imager
Download link : https://releases.ubuntu.com/22.04.1/ubuntu-22.04.1-live-server-amd64.iso for Ubuntu 22.04 **jammy**

### In this tutorial we will be using an Ubuntu server 20.04 with Litespeed webservice.  
Why Litespeed?  
1. It outperforms IIS, Apache and NGINX : https://chemicloud.com/blog/litespeed-vs-nginx-vs-apache/
2. It offers built-in DDOS protection by default : https://docs.litespeedtech.com/cp/cpanel/antiddos/
3. It allows management of your site(s) using a web interface : https://www.youtube.com/watch?v=KTdow8vEQuQ for more info


- We will setup the emulator as a service, therefore no action is required after an reboot.
- We will also setup Nitro Imager as a PM2 service (this is what renders your avatar figures), therefore no action is required after an reboot.

So, in the end, this will:

* Lower on hardware usage, also saving server costs.
* Lower on server costs, due to the fact no Windows license is required.
* Greater website perfomance in comparison to IIS, Apache and NGINX.

When starting from scratch, this would be the recomended order :
1. Cosmic Setup  
2. Imager and Gamedata setup  
3. Cloudflare and SSL setup  
4. Cloudlfare RealIP setup  
5. Cosmic badge system setup  
6. Emulator setup  
7. Nitro and settings setup  

**Big Thanks to:**  
Raizer (Cosmic CMS)  
Nitro Team for the Client
Krews Team for the Emulator  
Remco  
Ridge (Filling painsteaking all catalogue pages on the smallest laptop display ever.)  
TheGeneral (Initial base DB)  
TenShie (Crackables, Soundtracks, Crafting, TargedOffers, Roombundles, Calendar)  
Skeletor for the group bagde imager  

:white_check_mark: Setup Cosmic / Arcturus Database / Custom Catalog : 100%  
:white_check_mark: Imager : 100%  
:white_check_mark: Cloudflare and SSL : 100%  
:white_check_mark: Badges / Groupbadges : 100%  
:white_check_mark: Emulator : 100%  
:white_check_mark: Nitro setup : 100%
