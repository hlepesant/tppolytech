# TP Docker : Episode 2

# Création d'une stack Wordpress dans des containers Docker avec Haute Disponibilité

## Rappels

Les prérequis pour faire fonctionner l'application web [Wordpress](https://wordpress.org/) sont les suivantes :
 - Un serveur Web (Aapche2, Nginx)
 - PHP (7.x)
 - Un serveur de base de données (MySQL)


## Fonctionnement

```

                     __________________________________________________________________________
______________       |   _____________     _____________       __________        __________   |
|            |       |   |           |     |           |       |         |       |         |  |  
| Navigateur |  <->  |   | Traefik   | <-> |   Nginx   |  <->  |   PHP   |  <->  |  MySQL  |  |
|    Web     |       |   |           |     |           |       |   FPM   |       |         |  |
|____________|       |   |___________|     |___________|       |_________|       |_________|  |
                     |                                                                        |
                     |_________________________________Docker_________________________________|
```


* Le navigateur web se connecte sur le port 8000 (http) d'une IP.  
* Le load-balancer réparti le traffic vers une ferme de Nginx 
* Les serveurs Nginx demandent à PHP-FPM d'interpréter les fichiers PHP.  
* Lors de cette interprétation PHP-FPM va aller chercher des données dans la base de données MySQL.  

## Objectif

Ecrire un fichier [docker-compose.yml](https://docs.docker.com/compose/compose-file/) dans le quel seront déclarés 4 "services" :

 * Un container traefik
 * Un container nginx
 * Un container php-fpm
 * Un container mysql

### Container Traefik

Utilisez une [image officielle](https://hub.docker.com/_/traefik) pour démarrer le container.  
Le port 80 du container sera exposé et accessible par le port 8000.  


### Container Nginx

Utilisez une [image officielle](https://hub.docker.com/_/nginx) pour démarrer le container.  
Le container nginx sera "linké" au container php-fpm.

### Container MySQL

Uitiliser une [image officielle](https://hub.docker.com/_/mysql).   
Créer un volume persistent qui sera attaché au container.  
Ainsi les données ajoutées dans votre base de données ne seront pas perdues à chauqe re-démarrage de votre container MySQL


### Container PHP-FPM

Cette fois-ci nous allons créer notre image Docker avec un Dockerfile.  
En se basant sur une [image Debian officielle](https://hub.docker.com/_/debian) créer une image Docker permettant de lancer le service PHP-FPM.  
Avec notre Dockerfile nous installerons des paquets PHP de Debian.  
Les paquets sont les suivants :
 - php7.4-fpm
 - php7.4-mysql
 - php7.4-gd
 - php7.4-imagick
 - php7.4-intl
 - php7.4-mbstring
 - php7.4-xml
 - php7.4-curl
 - php7.4-apcu
Le container sera "linké" avec le container MySQL.


## Wordpress

La dernière version de [Wordpress](https://fr.wordpress.org/download/) sera décompressée dans un répertoire local.  
Le répertoire sera monté sous forme de "volume" dans les containers Nginx et PHP-FPM.


## Elements fournis

* Nginx : Le fichier de configuration à monter dans votre container dans /etc/nginx/conf.d/
* PHP-FPM : Les fichiers de configuration à copier dans l'image que vous allez builder. Ils sont dans "phpfpm/config"
* Le script getwp.sh qui télécharge la dernière version de Wordpress et la décompresse en local. Le répertoire devra être monté dans les containers Nginx et PHP-FPM dans le répertoire /var/www/html/



# Scaling Up and Down

## Scale Up
```
docker-compose up -d
docker-compose up --scale web=2 -d
```

## Scale Down
```
docker-compose up --scale web=1 -d
```

# Cleaning
```
docker-compose stop
docker-compose rm
docker volume rm tppolytech_dbdata
```
