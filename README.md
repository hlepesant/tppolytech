# TP Polytech Tours DI-4

## TP 2

### Premier Dockerfile

Prérequis : TP1

Objectif : Stack Apache/PHP5/MySQL

Dans 2 containers

#### WARNING :

Il faut modifier le fichier /etc/default/docker car dockerd ne fonctionne pas avec dnsmasq sous Ubuntu.

```
vim /etc/default/docker
...
#DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4"
DOCKER_OPTS="--dns 192.168.238.2"
...
sudo service docker restart
```

#### Opérations :

1. git clone https://github.com/hlepesant/tppolytech.git
1. cd tppolytech
1. git checkout TP2
1. cd mysql
1. ./server.sh
1. ./client.sh
1. cd ..
1. cd apache
1. ./run.sh
1. Open : http://do.ck.er.ip:8080/
1. Ctrl+c
1. docker ps
1. docker ps -a
1. docker stop mysql
1. docker rm mysql
1. docker images
1. docker rmi tp2_web
