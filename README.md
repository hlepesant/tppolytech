# Polytech Tours

## Objectif

 - Création d'une stack Wordpress dans des containers Docker

## Rappels

Les prérequis pour faire fonctionner l'application web [Wordpress](https://wordpress.org/) sont les suivantes :
 - Un serveur Web (Aapche2, Nginx)
 - PHP (7.x)
 - Un serveur de base de données (MySQL)

 


```bash
git clone https://github.com/hlepesant/tppolytech.git
sh ./getwp.sh
docker-compose up -d
sudo sh -c 'echo "127.0.0.1     wp.polytech.io" >> /etc/hosts'
```

Then browse [http://wp.polytech.io:8080/](http://wp.polytech.io:8080/)
