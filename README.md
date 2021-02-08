# TP Docker : Création d'une stack Wordpress dans des containers

## Rappels

L'application web [Wordpress](https://wordpress.org/) nécessite :
 - Un serveur Web (Aapche2, Nginx)
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
utiliser [docker-compose](https://docs.docker.com/compose/).


# Les différentes étapes de l'atelier

## 1 Installer Docker Compose

Suivre la procédure d'installation de [docker-compose](https://docs.docker.com/compose/install/)
sur la VM Ubuntu de la semaine dernière.

Profitez-en pour install [jq](https://stedolan.github.io/jq/)

```shell
apt-get update
apt-get -y install jq
```

Cet outils nous permettra de faire des recherches dans les sorties de Docker au
format [JSON](https://en.wikipedia.org/wiki/JSON).

## 2 Créer le fichier docker-compose.yml

Créez un répertoire "atelier", et placez-vous dedans.

```shell
mkdir atelier
cd atelier
```

C'est dans ce répertoire que nous allons créer le fichier docker-compose.yml.

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

### 1.1  Version

Ajouter les lignes suivantes à votre fichier docker-compose.yml.
```yaml
version: '3.8'
```

### 1.2 Volumes

Avec "volumes" nous allons pouvoir créer des volumes de différents types, et les
partager entre différents services sans passer par l'option "volume_from".  
Ainsi nous pouvons créer des volumes persistant et ne plus perdre les données
entre deux démarrages de container.

Notre premier volume sera celui de la base de données.  
Nous l'attacherons dans deuxième temps u service MySQL.  
Nous appelerons ce volume "bdd_data".  
Modifions le fichier docker-compose.yml en ajoutant la section suivante :

```yaml
volumes:
    bdd_data:
```

Lancer les commandes :
```shell
docker-composer config
docker-compose up -d
```

Qu'observez-vous ?

Lancer les commandes :
```shell
docker-compose ps
docker volume ls
docker volume inspect atelier_bdd_data | jq .
docker volume inspect atelier_bdd_data | jq .[0]
```

### 1.3 Service

Dans cette section, nous allons définir les trois services suivants :

 * bdd : pour le container MySQL
 * php : pour le container PHP
 * web : pour le container Nginx


#### 1.3.1 Service "bdd" (aka MySQL)

Ce service ne sera pas exposé en dehors de la slack (réseau interne Docker).  
Il sera "linké" au service PHP (on verra ça plus tard).  

Il existe une image [Docker MySQL officielle](https://hub.docker.com/_/mysql).   
Nous allons l'utiliser pour notre service "bdd".

Rechercher dans la [documentation de l'image MySQL](https://hub.docker.com/_/mysql)
comment faire pour :

 * Définir un mot de passe pour l'utilisateur "root" de MySQL ?
 * Définir un username, et son mot de passe, autre que "root" ?
 * Créer automatiquement une base de données "wordpress" ?
 * Contourner le plugin d'authentification de MySQL 8, et revenir au plugin natif

Et dans la documentation sur les [volumes](https://github.com/compose-spec/compose-spec/blob/master/spec.md#volumes-top-level-element), comment utiliser notre volume "bdd_data".


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
docker-compose up -d
docker-compose logs -f
docker-compose logs bdd | grep Entrypoint
```

Qu'observez-vous ?
Le container MySQL est-il toujours actif ?
La base de données "wordpress" a-t-elle été créée ?  
Comment ?

Dans une autre console, lancer la commande suivante :

```shell
docker-compose exec -- bdd bash -c 'mysql -uroot -p$MYSQL_ROOT_PASSWORD'
```

Que s'est il passé ?
Comparer les commandes :

```shell
docker-compose exec -- bdd bash -c 'mysql -uroot -p$MYSQL_ROOT_PASSWORD'
```
et
```shell
docker exec -ti <CONTAINER_ID> bash -c 'mysql -uroot -p$MYSQL_ROOT_PASSWORD'
```

en remplaçant '<CONTAINER_ID>' par l'ID du container de la commande `docker ps`.  


Vous  êtes connecté à la base de données.
Nous allons afficher les bases de données existantes :

```shell
mysql> show databases;
```

Voyez-vous la base de données `wordpress` ?  



Créer la base de donnée `polytech` :
```shell
mysql> create database polytech;
mysql> show databases;
```

Trouvez-vous la base de données `polytech` ?

Revenez sur la console précédente, et taper "Ctrl+C".
Lancer la commande :

```shell
docker-compose start
docker-compose exec -- bdd bash -c 'mysql -uroot -p$MYSQL_ROOT_PASSWORD'
```


<details><summary>Solution</summary>
<p>

Pour la partie base de données il faut définir de$s variables d'environnement.  
Et pour utiliser le bon plugin, il faut utiliser le pramètre `command`.

Cela donne ceci :

```yaml
services:
    bdd:
        image: mysql:8.0
        volumes:
            - bdd_data:/var/lib/mysql
        command: --default-authentication-plugin=mysql_native_password
        environment:
            MYSQL_ROOT_PASSWORD: password
            MYSQL_DATABASE: wordpress
            MYSQL_USER: wordpress
            MYSQL_PASSWORD: password
```
</p>
</details>


_Remarques_:

Préciser les [variables d'environnement](https://docs.docker.com/compose/environment-variables/) suivantes dans votre fichier docker-compose.yml :  

 * MYSQL_ROOT_PASSWORD : This variable is mandatory. It defines the password that will be set for the MySQL root superuser account
 * MYSQL_DATABASE : This variable is optional and allows you to specify the name of a database to be created on image startup
 * MYSQL_USER et MYSQL_PASSWORD : These variables are optional, used in conjunction to create a new user and to set that user's password

De plus, si vous décidez d'utiliser une version 8.x de MySQL, il faut étendre la commande de lancemenet de MySQL avec l'option :
```
--default-authentication-plugin=mysql_native_password
```







## Service Nginx

Utilisez une [image officielle](https://hub.docker.com/_/nginx) pour démarrer le container.  
Le port 80 du container sera exposé et accessible par le port 8080.  
Le container nginx sera "linké" au container php-fpm.

### Container PHP-FPM

Cette fois-ci nous allons créer notre image Docker avec un Dockerfile.  
En se basant sur une [image Debian officielle](https://hub.docker.com/_/debian) créer une image Docker permettant de lancer le service PHP-FPM.  
Avec notre Dockerfile nous installerons des paquets PHP de Debian.  
Les paquets sont les suivants :
 - php7.3-fpm
 - php7.3-mysql
 - php7.3-gd
 - php7.3-imagick
 - php7.3-intl
 - php7.3-mbstring
 - php7.3-xml
 - php7.3-curl
 - php7.3-apcu
Le container sera "linké" avec le container MySQL.


## Wordpress

La dernière version de [Wordpress](https://fr.wordpress.org/download/) sera décompressée dans un répertoire local.  
Le répertoire sera monté sous forme de "volume" dans les containers Nginx et PHP-FPM.


## Elements fournis

* Nginx : Le fichier de configuration à monter dans votre container dans /etc/nginx/conf.d/
* Le script getwp.sh qui télécharge la dernière version de Wordpress et la décompresse en local. Le répertoire devra être monté dans les containers Nginx et PHP-FPM dans le répertoire /var/www/html/


 Bonne chance.
