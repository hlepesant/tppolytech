# TP Docker 2 : Création d'une stack Wordpress dans des containers

## Rappels

L'application web [Wordpress](https://wordpress.org/) nécessite :
 - Un serveur Web (Apache2, Nginx)
 - PHP (7.x)
 - Un serveur de base de données (MySQL)

## Objectif

Pendant cet atelier nous allons donc de démarrer une stack applicative complète
à l'aide de containers.  

```
                     ________________________________________________________
______________       |   _____________       __________        __________   |
|            |       |   |           |       |         |       |         |  |  
| Navigateur |  <->  |   |   Nginx   |  <->  |   PHP   |  <->  |  MySQL  |  |
|    Web     |       |   |           |       |   FPM   |       |         |  |
|____________|       |   |___________|       |_________|       |_________|  |
                     |                                                      |
                     |____________________Docker____________________________|
```

## Fonctionnement

* Le navigateur web se connecte sur le port 80 (http) d'une IP.  
* Le serveur Nginx demande à PHP-FPM d'interpréter les fichiers PHP.  
* Lors de cette interprétation PHP-FPM va aller chercher des données dans la
base de données MySQL.  

Pour pouvoir lancer notre stack en une seule ligne de commande, nous allons
utiliser [docker compose](https://docs.docker.com/compose/).

Exemple de script :
```shell
#!/bin/bash

sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world
```


# Les différentes étapes de l'atelier

## Installer Docker Compose

Suivre la procédure d'installation de [docker-compose](https://docs.docker.com/compose/cli-command/#install-on-linux) version 2.x.
sur la VM Ubuntu 18.04 de la semaine dernière, celle où vous aviez installer
[Docker](https://www.docker.com/).

:warning:
Cette installation de *docker-compose* se fait sous la forme d'une extension (plugins) de Docker.  
Cela se traduit par une utilisation de la commande :
```
docker compose <cmd>
```
Et non plus :
```
docker-compose  <cmd>
```

Profitez-en pour install [jq](https://stedolan.github.io/jq/).  
En effet nous profiterons de ce TP pour appréhender cet outils.

```shell
apt-get update
apt-get -y install jq
```

## Répertoire de travail

Toutes les actions suivantes seront réalisées dans un répertoire "atelier".
Créez ce répertoire "atelier", et placez-vous dedans.

```shell
mkdir atelier
cd atelier
```

## Récupérer la dernière version de Wordpress

C'est l'application web que nous voulons déployer avec nos containers. Nous
devons donc récupérer les sources.  
Pour cela récupérer le script [getwp.sh](https://raw.githubusercontent.com/hlepesant/tppolytech/master/getwp.sh).  

```shell
wget https://raw.githubusercontent.com/hlepesant/tppolytech/master/getwp.sh
chmod +x getwp.sh
./getwp.sh
```

Le script télécharge la dernière version de Wordpress francisée,
décompresse l'archive dans le répertoire "wordpress",
créer quelques répertoires pour le bon fonctionnement de l'application,
et prépare le fichier de configuration de wordpress (wordpress/wp-config.php).  
Nous utiliserons plus tard ce répertoire comme volume partagé avec Docker.  


## Créer le fichier docker-compose.yml


Toujours dans ce répertoire "atelier", créez le fichier docker-compose.yml.  

Docker-compose utilise la syntax [YAML](https://fr.wikipedia.org/wiki/YAML).  
Ce fichier est divisé en plusieurs éléments de "haut niveau" :

 * [Version](https://github.com/compose-spec/compose-spec/blob/master/spec.md#version-top-level-element)
 * [Volumes](https://github.com/compose-spec/compose-spec/blob/master/spec.md#volumes-top-level-element)
 * [Services](https://github.com/compose-spec/compose-spec/blob/master/spec.md#services-top-level-element)
 * [Networks](https://github.com/compose-spec/compose-spec/blob/master/spec.md#networks-top-level-element)
 * [Secrets](https://github.com/compose-spec/compose-spec/blob/master/spec.md#secrets-top-level-element)
 * [Configs](https://github.com/compose-spec/compose-spec/blob/master/spec.md#configs-top-level-element)


Les spécifications complète d'un fichier docker-compose.yml peuvent être trouvées
[ici](https://github.com/compose-spec/compose-spec/blob/master/spec.md), mais
nous allons faire simple en n'utilisant que :
 * [Version](https://github.com/compose-spec/compose-spec/blob/master/spec.md#version-top-level-element)
 * [Volumes](https://github.com/compose-spec/compose-spec/blob/master/spec.md#volumes-top-level-element)
 * [Services](https://github.com/compose-spec/compose-spec/blob/master/spec.md#services-top-level-element)


 C'est parti, utilisez votre éditeur de texte préféré pour créer le fichier docker-compose.yml.

 ```shell
 vi docker-compose.yml
 ```

### Version

Ajouter les lignes suivantes à votre fichier docker-compose.yml.

```yaml
version: '3.8'
```

### Volumes

Avec "volumes" nous allons pouvoir créer des volumes de différents types, et les
partager entre différents services sans passer par l'option "volume_from".  
Ainsi nous pouvons créer des volumes persistant et ne plus perdre les données
entre deux démarrages de container.

Notre premier volume sera celui de la base de données.  
Nous l'attacherons dans un deuxième temps au service MySQL.  
Nous appellerons ce volume "bdd_data".  
Modifions le fichier docker-compose.yml en ajoutant la section suivante :

```yaml
volumes:
    bdd_data:
```

Lancer les commandes :
```shell
docker composer config
docker compose up -d
```

Qu'observez-vous ?

Lancer les commandes :
```shell
docker compose ps
docker volume list
```

Notez le nom du volume.  Docker-compose a nommé le volume avec pour préfix le
répertoire dans lequel la commande "docker-compose" a été lancée.  

Maintenant inspectons le volume :

```shell
docker volume inspect atelier_bdd_data | jq .
docker volume inspect atelier_bdd_data | jq .[0]
docker volume inspect atelier_bdd_data | jq .[0].Mountpoint
```

Observez la coloration syntaxique offerte par "jq".  
Et l'utilisation de filtre pour afficher les informations voulues.  

Afficher le contenu du répertoire correspondant au "Mountpoint".  
Que notez-vous ?


### Les Services

Dans cette section, nous allons définir les trois services suivants :

 * bdd : pour le container MySQL
 * php : pour le container PHP
 * web : pour le container Nginx


#### Service "bdd" (aka MySQL)

Il existe une image [Docker MySQL officielle](https://hub.docker.com/_/mysql).   
Nous allons l'utiliser pour notre service "bdd".

Rechercher dans la [documentation de l'image MySQL](https://hub.docker.com/_/mysql)
comment faire pour :

 * Définir un mot de passe pour l'utilisateur "root" de MySQL ?
 * Définir un username, et son mot de passe, autre que "root" ?
 * Créer automatiquement une base de données "wordpress" ?
 * Contourner le plugin d'authentification de MySQL 8, et revenir au plugin natif

Et dans la documentation sur les [volumes](https://github.com/compose-spec/compose-spec/blob/master/spec.md#volumes-top-level-element), comment utiliser notre volume "bdd_data" défini plus haut.


<details><summary>solution service bdd</summary>
<p>

```yaml
services:
    bdd:
        image: mysql:8.0
        command: --default-authentication-plugin=mysql_native_password
        volumes:
            - bdd_data:/var/lib/mysql
        environment:
            MYSQL_ROOT_PASSWORD: password
            MYSQL_DATABASE: wordpress
            MYSQL_USER: wordpress
            MYSQL_PASSWORD: password
```
</p>
</details>


Une fois que le fichier docker-compose.yml est sauvegardé, lancer les commandes :

```shell
docker compose up -d
docker compose logs -f
docker compose logs bdd | grep Entrypoint
```

- Qu'observez-vous ?
- Le container MySQL est-il toujours actif ?
- La base de données "wordpress" a-t-elle été créée ?  
- Comment ?
- Afficher à nouveau le contenu du répertoire correspondant au "Mountpoint"
du volume "bdd_data"

#### Continuons de jouer avec notre container MySQL.  

Exécuter la commande suivante :

```shell
docker compose exec -- bdd bash -c 'mysql -uroot -p$MYSQL_ROOT_PASSWORD'
```

Que s'est il passé ?
Comparer les commandes :

```shell
docker compose exec -- bdd bash -c 'mysql -uroot -p$MYSQL_ROOT_PASSWORD'
```
et
```shell
docker exec -ti <CONTAINER_ID> bash -c 'mysql -uroot -p$MYSQL_ROOT_PASSWORD'
```

en remplaçant '<CONTAINER_ID>' par l'ID du container de la commande `docker ps`.  

En effet, vous  êtes connecté à la base de données.  
Nous allons afficher les bases de données existantes :

```shell
mysql> show databases;
```

Voyez-vous la base de données `wordpress` ?  

_Remarques_:

Les [variables d'environnement](https://docs.docker.com/compose/environment-variables/)
sont très souvent utilisées pour passer des options aux images Docker.

### Service PHP

Il existe des images [Docker pour PHP](https://hub.docker.com/_/php), cependant
nous allons construire notre propre image avec un Dockerfile, en se basant sur
l'image [debian:bullseye-slim](https://hub.docker.com/_/debian)

Toujours dans le répertoire "atelier", créer un sous-répertoire "php".  

```shell
mkdir phpfpm
vi phpfpm/Dockerfile
```

A noter que l'installation de PHP-FPM sur un serveur ou une machine virtuelle
pourrait être fait par le script shell suivant :

```shell
export DEBIAN_FRONTEND="noninteractive"
apt-get update
apt-get install apt-transport-https lsb-release ca-certificates gnupg2 procps \
  php7.4-common php7.4-cli php7.4-fpm php7.4-mysql php7.4-apcu php7.4-gd \
  php7.4-imagick php7.4-curl php7.4-intl php-redis
apt-get clean
apt-get autoclean
mkdir /var/run/php
```

Il faudra aussi modifier quelques fichiers.  
Cependant comme vous ne pouvez pas utiliser un éditeur de texte lors du build
d'une image

_/etc/php/7.4/fpm/php.ini_

* Pour augmenter la verbosité de PHP-FPM :
```shell
sed -i 's/error_reporting = .*/error_reporting = E_ALL/' /etc/php/7.4/fpm/php.ini
```

_/etc/php/7.4/fpm/php-fpm.conf_

* Faire en sorte que PHP-FPM, ne soit pas lancer en arrière plan.
```shell
sed -i 's/\;daemonize.*/daemonize = no/' /etc/php/7.4/fpm/php-fpm.conf
```
* Rediriger les logs vers la sortie standard :
```shell
sed -i 's/error_log = .*/error_log = \/proc\/self\/fd\/2/' /etc/php/7.4/fpm/php-fpm.conf
```

_/etc/php/7.4/fpm/pool.d/www.conf_

* Configuration d'un "pool" de PHP-FPM :

```shell
sed -i 's/\;clear_env = .*/clear_env = no/' /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /etc/php/7.4/fpm/pool.d/www.conf
```

Je vous invite à le traduire en Dockerfile les indications ci-dessus.  
A noter que le port 9000 sera exposé, et que le service PHP et Nginx doivent
partager les sources de Wordpress selon le même PATH. Cela se fera sous la forme
d'un volume Docker.


<details><summary>solution Dockerfile php</summary>
<p>

```
FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y install apt-transport-https \
        lsb-release \
        ca-certificates \
        gnupg2 \
        procps \
        php7.4-common \
        php7.4-cli \
        php7.4-fpm \
        php7.4-mysql \
        php7.4-apcu \
        php7.4-gd \
        php7.4-imagick \
        php7.4-curl \
        php7.4-intl \
        php-redis \
        net-tools \
        default-mysql-client \
    && apt-get clean \
    && apt-get autoclean

RUN sed -i 's/error_reporting = .*/error_reporting = E_ALL/' /etc/php/7.4/fpm/php.ini
RUN sed -i 's/\;daemonize.*/daemonize = no/' /etc/php/7.4/fpm/php-fpm.conf
RUN sed -i 's/error_log = .*/error_log = \/proc\/self\/fd\/2/' /etc/php/7.4/fpm/php-fpm.conf

RUN mkdir /var/run/php

VOLUME /usr/share/nginx/html

EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.4", "--nodaemonize"]
```
</p>
</details>

Maintenant que votre Dockerfile build une image Docker.  Intégrer la dans le
fichier docker-compose.yml.  

Il faudra ajouter :
* les [variables d'environment](https://docs.docker.com/compose/environment-variables/#set-environment-variables-in-containers)
que vous retrouverez dans le fichier "wordpress/wp-config.php" créer par le script
"getwp.sh".  
* le [volume](https://docs.docker.com/storage/volumes/#start-a-container-with-a-volume)
correspondant au répertoire contenant les sources de Wordpress,
* [lié](https://docs.docker.com/compose/networking/#links) le service "php", au service "bdd".

Vous pouvez vous baser sur le template présent dans le répertoire "phpfpm".  


<details><summary>solution service php</summary>
<p>

```
php:
  build:
    context: ./phpfpm
  volumes:
    - ./wordpress:/usr/share/nginx/html
  environment:
    MYSQL_DATABASE: wordpress
    MYSQL_USER: wordpress
    MYSQL_PASSWORD: password
    MYSQL_HOST: bdd
  links:
    - bdd
```
</p>
</details>

Lancer les commandes suivantes :
```shell
docker compose up -d
docker compose ps
docker composer logs
```

Qu'observer vous ?


### Service Nginx

Comme pour MySQL, nous allons utiliser l'[image officielle](https://hub.docker.com/_/nginx)
pour le service web.  
Le port 80 du container sera exposé et accessible par le port 8000.  
Le container nginx sera "linké" au container php-fpm.
Il y aura deux volumes :
1. le source de Wordpress
2. un répertoire contenant un fichier de configuration d'un
[hôte virtuel](https://www.nginx.com/resources/wiki/start/topics/examples/server_blocks/)

Le but de l'atelier n'étant pas d'apprendre à configurer Nginx. Une version est
proposé dans le répertoire "nginx/conf.d/" (cf commande ci-dessous). Ce répertoire sera le deuxième
volume à monter dans le container.

Pour créer ce fichier de config "default.conf" :
```shell
mkdir -p nginx/conf.d
wget https://raw.githubusercontent.com/hlepesant/tppolytech/master/nginx/conf.d/default.conf -O nginx/conf.d/default.conf
```

<details><summary>solution service web</summary>
<p>

```
web:
  image: nginx:mainline
  volumes:
    - ./wordpress:/usr/share/nginx/html
    - ./nginx/conf.d:/etc/nginx/conf.d
  ports:
    - "8000:80"
  links:
    - php
```
</p>
</details>


Lancer les commandes suivantes :
```shell
docker compose up -d
docker compose ps
docker composer logs
```

Qu'observer vous ?

## Check

Lancer votre navigateur et connecter vous sur l'url : http://<IP VM>:8000/

## Clean

```shell
docker compose stop
docker compose rm
```
