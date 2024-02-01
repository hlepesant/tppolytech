# TP Docker : Episode 2

# Création d'une stack Wordpress dans des containers Docker

## Rappels

Les prérequis pour faire fonctionner l'application web [Wordpress](https://wordpress.org/) sont les suivantes :
 - Un serveur Web (Apache2, Nginx)
 - PHP (8.x)
 - Un serveur de base de données (MySQL)

## Fonctionnement

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


* Le navigateur web se connecte sur le port 80 (http) d'une IP.  
* Le serveur Nginx demande à PHP-FPM d'interpréter les fichiers PHP.  
* Lors de cette interprétation PHP-FPM va aller chercher des données dans la base de données MySQL.  

## Objectif

Utiliser [docker-compose](https://docs.docker.com/compose/) pour lancer tous les containers en même temps.

Ecrire un fichier [docker-compose.yml](https://docs.docker.com/compose/compose-file/) dans le quel seront déclarés 3 "services" :

 * Un container mysql
 * Un container php-fpm
 * Un container nginx


### Container Nginx

Utilisez une [image officielle](https://hub.docker.com/_/nginx) pour démarrer le container.  
Le port 80 du container sera exposé et accessible par le port 8080.  
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
 - php8.2-fpm
 - php8.2-mysql
 - php8.2-gd
 - php8.2-imagick
 - php8.2-intl
 - php8.2-mbstring
 - php8.2-xml
 - php8.2-curl
 - php8.2-apcu
Le container sera "linké" avec le container MySQL.


## Wordpress

La dernière version de [Wordpress](https://fr.wordpress.org/download/) sera décompressée dans un répertoire local.  
Le répertoire sera monté sous forme de "volume" dans les containers Nginx et PHP-FPM.


## Elements fournis

* Nginx : Le fichier de configuration à monter dans votre container dans /etc/nginx/conf.d/
* Le script getwp.sh qui télécharge la dernière version de Wordpress et la décompresse en local. Le répertoire devra être monté dans les containers Nginx et PHP-FPM dans le répertoire /var/www/html/


 Bonne chance.
