# TP Docker : Episode 2

## Objectif

 - Création d'une stack Wordpress dans des containers Docker

## Rappels

Les prérequis pour faire fonctionner l'application web [Wordpress](https://wordpress.org/) sont les suivantes :
 - Un serveur Web (Aapche2, Nginx)
 - PHP (7.x)
 - Un serveur de base de données (MySQL)

## Fonctionnement

```

                    _____________________________________________________
______________      |   _____________     __________       __________   |
|            |      |   |           |     |         |      |         |  |  
| Navigateur |  ->  |   |   Nginx   |  -> |   PHP   |  ->  |  MySQL  |  |
|    Web     |      |   |           |     |   FPM   |      |         |  |
|____________|      |   |___________|     |_________|      |_________|  |
                    |                                                   |
                    |_______________________Docker______________________|
```

* Le navigateur web se connecte sur le port 80 (http) d'une IP.  
* Le serveur Nginx demande à PHP-FPM d'interpréter les fichiers PHP.  
* Lors de cette interprétation PHP-FPM va aller chercher des données dans la base de données MySQL.  