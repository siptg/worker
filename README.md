# How to configure the worker
Run the following commands at home path:
```
apt-get update
apt-get upgrade
wget get.docker.com -O - -o /dev/null | sudo sh
apt-get install docker-compose dnsutils
wget -qO- https://github.com/siptg/worker/archive/master.tar.gz | tar xvz
cd worker-master
```

Get the `cert.pem` and `key.pem` from the [@siptg_bot](https://t.me/siptg_bot) and push it to `ssl` directory inside `worker-master` (create if it not exists).

Next, verify and change if needed the worker's managing port which will be used to connect to your worker from sip.tg service. It is located at `nginx/nginx.conf` file under the section `stream`->`server`->`listen`. If you are is under the NAT, verify the port mapping at the NAT as well. Also don't forget to allow incoming connections for the specified port at your firewall if needed.

Next, run the worker by command:
```
docker-compose create worker nginx && docker-compose start worker nginx
```

After that set the host's `address:port` in the bot and push `Turn on` button. You're done!
