# Litespeed and Cloudflare setup
In OpenLiteSpeed web server, setting up a SSL certificate for a domain is a bit tricky.  
In this article I will show how to setup Cloudflare’s free SSL certificate for a domain name.  
Before we begin, make sure that your domain is using Cloudflare’s DNS.  

## Getting certificate from Cloudflare

1. Login to your Cloudflare dashboard and select your domain.  

2. Click on “Crypto” tab and within SSL settings, select “Full (strict)”  

3. Scroll down a bit and within “Origin Certificates” settings, click “Create Certificate”  

4. A pop up window will open. Under the “List the hostnames”, you will see your domain name.  

If you want to host multiple domains in your web server, then you can also add those domains in that field.  
Make sure that certificate validity is set to 15 years.  
Now click next.  
You will see the certificate file and along with key file that has been generated according to your domain name.  
We need that certificate file and key file later for the web server.

5. Do not close the window and copy the contents of the “Origin Certificate” box.  
Create an empty file named “ssl.pem” and paste the copied contents within that file.  
Follow the similar step for “Private key” and save the file as “ssl.key”

## Setup Web Server to use generated certificates
First, transfer those .pem and .key files to /usr/local/lsws/conf/cert directory. (use WINSCP or any other SSH transfer tool)  
Now to use those files in our Web Server, we need to configure the SSL settings for port 443 listener.

1. Login to OpenLiteSpeed control panel and navigate to “Listeners” and click “Add”
Set the following values:
```text
Listener name: 443 (or any name)
IP Address: ANY
Port: 443
Secure: Yes
```
Click Save icon  

2. Your newly created listener will be added to listener list.  
Now click “View” to open the listener  

3. Go to “SSL” tab and click edit  
Fill out the following values:  
```text
Private Key File: /usr/local/lsws/conf/cert/ssl.key
Certificate FIle: /usr/local/lsws/conf/cert/ssl.pem
```  

4. Get back to the “SSL” tab and click “Edit” icon in “SSL Protocol” settings  
Select :  
```
TLS v1.2
TLS v1.3      
```
5. Now head back to the “Listeners” > “General” tab. Under “Virtual Host Mappings”, click “Add”  
Set “Virtual Host” for your domain and specify the domain name (mydomain.com).  
Click save icon.

Change the following to use your own Imager
```shell
vi /var/www/retrohotel/CMS/src/App/Config.php
```
```text
      "domain"      => "https://###Your Domain or IP###",
      "cpath"       => "https://###Your Domain or IP###/assets",
      "fpath"       => "https://###Your Domain or IP###/imaging/",
      "shortname"   => "Cosmic Test",
      "sitename"    => "Cosmic Test"
```

Reboot your server and test it out!
