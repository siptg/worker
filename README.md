# How to configure the worker
Update the software of your system. For example, on Ubuntu/Debian system use the following commands:
```
apt-get update
apt-get upgrade
```

Next, setup docker and download latest configs:
```
cd ~
wget get.docker.com -O - -o /dev/null | sudo sh
apt-get install docker-compose dnsutils
wget -qO- https://github.com/siptg/worker/archive/master.tar.gz | tar xvz
cd worker-master
```

Get the `cert.pem` and `key.pem` from the [@siptg_bot](https://t.me/siptg_bot) and push it to `ssl` directory inside `worker-master` (create if it not exists).

Next, verify and change if needed the worker's managing port which will be used to connect to your worker from sip.tg service (see [below](#default-ports-which-are-used-by-the-worker)). If you are is under the NAT, verify the port mapping at the NAT as well. Also don't forget to allow incoming connections for the specified port at your firewall if needed.

Note, if you're going to run the Worker on the platform other than **amd64**, you have to change the images in `docker-compose.yml`. Available platforms see on [Docker Hub](https://hub.docker.com/r/siptg/worker/tags/).

Next, run the worker by command:
```
docker-compose create worker nginx && docker-compose start worker nginx
```

After that set the host's `address:port` in the bot and push `Turn on` button. You're done!

## Default ports which are used by the worker
| Port   	| Type 	| Area  	| Description            	| To change                                              	|
|--------	|------	|-------	|------------------------	|--------------------------------------------------------	|
| 50001*  | TCP  	| all   	| Worker module external 	| nginx/nginx.conf: `stream`→`server`→`listen`           	|
| 12345 	 | TCP  	| local 	| Worker module internal 	| yate/conf/extmodule.conf: `listener tg_gateway`→`port` 	|
| 50600  	| UDP  	| all   	| SIP signaling          	| yate/conf/ysipchan.conf: `general`→`port`              	|
| 5038  	 | TCP  	| local 	| Yate RManager          	| yate/conf/rmanager.conf: `general`→`port`              	|
 
\* - the port which you have to provide to the bot.

## Symmetric NAT
If you're using VPS service with symmetric NAT (like Amazon or Scaleway; the IP address of your ethernet adapter is private), you have to set an additional option. Set into `yate/conf/ysipchan.conf`: `general`→`nat_address` your real global address.

# Managing the worker
## Restart
Inside `worker-master` directory run:
```
docker-compose restart worker
```

## Update
Inside `worker-master` directory run:
```
docker-compose pull worker && docker-compose create worker && docker-compose start worker
```
