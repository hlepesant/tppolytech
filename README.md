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