# TP Docker : Episode 2

# Création d'une stack Wordpress dans des containers Docker

## Rappels

Les prérequis pour faire fonctionner l'application web [Wordpress](https://wordpress.org/) sont les suivantes :
 - Un serveur Web (Aapche2, Nginx)
 - PHP (7.x)
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

Pour Nginx et MySQL utiliser des images officiels :
 - [MysqL](https://hub.docker.com/_/mysql)
 - [Nginx](https://hub.docker.com/_/nginx)

Pour PHP-FPM, nous allons utiliser un Dockerfile qui fabriquera une image à partir de [debian](https://hub.docker.com/_/debian):buster-slim.  
Dans le Dockerfile nous installerons les paquets PHP de Debian. Les paquets sont les suivants :
 - php7.3-fpm
 - php7.3-mysql
 - php7.3-gd
 - php7.3-intl
 - php7.3-mbstring
 - php7.3-xml

 Tous ça dans un fichier docker-compose.yml.

## Elements fournis

* Nginx : Le fichier de configuration à monter dans votre container dans /etc/nginx/conf.d/
* Le script getwp.sh qui télécharge la dernière version de Wordpress et la décompresse en local. Le répertoire devra être monté dans les containers Nginx et PHP-FPM dans le répertoire /var/www/html/


 Bonne chance.
