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

Next, run the worker by command:
```
docker-compose create worker nginx && docker-compose start worker nginx
```

After that set the host's `adderss:port` in the bot and push `Turn on` button. You're done!
