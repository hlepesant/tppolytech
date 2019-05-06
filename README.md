# TP Polytech Tours DI-4

## TP 2.1

Lancer un Wordpress via docker-compose.

Avec :

 - 1 service Mysql basé sur une image officielle mysql:5.7
 - 1 service Apache basé sur une image officielle debian:latest

Le service Apache est basé sur un Dockerfile dans lequel nous installons PHP7.0.
Le service Apache exose le port 8080, mappé sur le port 80.
Le service Apache est lié au service MySQL.
Les 2 services sont configurés par des variables d'environnement


#### Opérations :

 * git clone https://github.com/hlepesant/tppolytech.git
 * cd tppolytech
 * git checkout TP2.1
 * mkdir -p share/mysql/data
 * mkdir -p share/wordpress/html
 * docker-compose up -d


### Check

Ouvrez un navigateur sur http://localhost:8080
