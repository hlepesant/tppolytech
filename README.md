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
```

Et pour les distributions avec systemd
```diff
--- /lib/systemd/system/docker.service	2018-04-26 09:15:24.000000000 +0200
+++ /lib/systemd/system/docker.service	2018-05-18 16:01:09.480000000 +0200
@@ -10,7 +10,7 @@
 # the default is not to use systemd for cgroups because the delegate issues still
 # exists and systemd currently does not support the cgroup feature set required
 # for containers run by docker
-ExecStart=/usr/bin/dockerd -H fd://
+ExecStart=/usr/bin/dockerd -H fd:// --dns 192.168.238.2
 ExecReload=/bin/kill -s HUP $MAINPID
 LimitNOFILE=1048576
 # Having non-zero Limit*s causes performance problems due to accounting overhead
```
avec une prise en compte des modifications :
```
sudo systemctl daemon-reload
```
 
Ou encore dans le fichier /etc/docker/daemon.json
```json
{
   "dns":["192.168.238.2"]
}
```

Dans tous les cas :
```
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
