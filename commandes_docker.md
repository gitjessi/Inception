
# COMMANDE_DOCKER

``pour enlever le sudo``

...bash
	
	sudo usermod -aG docker $USER

puis rafraichir le terminal
pemet de rajouter notre USER au groupe docker

# changer le nom hostname 

Action	Commande / fichier

Trouver IP locale	ip a ou ipconfig

sudo nano /etc/hosts

	changer le hostname par <name>

# Conteneur

## Créer et lancer un conteneur

...bash

	docker run <nom de l'image>

## Créer un conteneur avec un nom et un hostname personnalisee

...bash

	docker run  -it --name <c2> --hostname <host1> <debian:latest>

	docker run -it --name <choisir un nom de conteneur> --hostname <choisir un nom root> <image>

## Lister des conteneurs

...bash

	docker ps 
	docker container ps

	docker ps -q
	permet de lister les Id des conteneurs actifs

## Lister tous les conteneurs

...bash

	docker ps -a
	docker container ps -a

	docker ps -qa
	permet de lister les Id des conteneurs actifs et inactifs

## Supprimer un ou des conteneurs // avant de supp un conteneur il faut l'arreter ( mode exited et non up)

...bash

	docker rm <id du conteneur> ou <3 premieres lettre du conteneur>:tag
	docker container rm <id du conteneur> ou <3 premieres lettre du conteneur>:tag

	docker rm -f $(docker ps -q)
	permet de supprimer tous les conteneurs actifs

	docker rm -f <nom du conteneur>
	permet de forcer la suppression du conteneur sans le stopper
	docker rm -f $(docker ps -qa)
	permet de supprimer tous les conteneurs actifs et inactifs


# Image

## Lister toutes les images

...bash

	docker image ls
	docker images


## Supprimer un ou plusieurs images

...bash

	docker image rm <id de l'image> ou <3 premieres lettre de l'image>
	docker rmi <id de l'image> ou <3 premieres lettre de l'image>

`` toujours supprimer le conteneur avant l'image sinon conflit ... ``


# Conteneur 

## Lancer un conteneur et interagir avec lui

...bash

	docker run -it <nom de l'image>

	le nom du conteneur sera choisi par default

## Créer un conteneur et le supprimer automatiquement

...bash

	docker run -it --rm <nom de l'image>

## Redemarrer un conteneur

...bash

	docker start <id conteneur>

## Arreter un conteneur

...bash

	docker stop <id conteneur>

## Entrer et interagir dans un conteneur (reste en UP)

...bash

	docker exec -it <id conteneur> bash 
	
	--> exec permet d'executer une commande ou programme sans rentrer dans le conteneur
	ex : docker exec <id> touch ficher.txt

## Redemarrer et interagir avec un conteneur en une ligne de commande

...bash

	docker start -ai <id>

## Installer un programme dans le conteneur

...bash

	apt update pour mettre a jour (apt = ubuntu)
	apt install -y <nom de programme>

# volume

## mapper

... bash

	docker run -it --rm -v <dossier local>:/dossier conteneur> <image>

## manager

### Creer un volume 

... bash

	docker volume create <choisir nom volume>

### Lister les volumes

...bash

	docker volume ls

### Supprimer un volume

...bash

	docker volume rm <nom du volume>

### Lier un volume manage

...bash

	docker run -it --rm -v <nom du volume>:</dossier conteneur> <image>

### Information du volume

...bash

	docker volume inspect <nom du volume>

# Port	

## Mapper des ports

	docker run -it --rm -p <port de notre machine local>:<port du conteneur> nginx
		faire sur internet http:localhost:<port de notre machine local> pour voir le contenu du port de nginx
		 ou
		faire dans le terminal :: curl 127.80.0.33:8080 
		curl < adress ip du reseau >:<port local>
		ou 
		curl http://localhost:<port local>

		pour connaitre l'adresse ip d'un reseau faire "ifconfig"

cette commande permet de de recuperer des informations du conteneur(port du conteneur) via notre port local

## Faire communiquer plusieurs conteneurs grace a IP et PING

	_ creer 2 conteneurs

	_ telecharger et installer 2 programmes dans chaque conteneur

		PING // permet de communiquer, d'envoyer un paquet dans une autre machine
	  		apt update && apt install -y iputils-ping

	 	IP // permet de connaitre l'adresse IP du conteneur ou machine
			apt update && apt install -y iproute2

	- verification des installations
		ping -h // aide
		ip -h // aide
	
	- recuperer l'IP de chaque conteneur // faire cette commande pour chaque conteneur

		 ip -c a
	
	- etablir la communication des conteneurs 

		ping <adresse ip du destinataire conteneur> ex 127.17.0.2/16
		--- envoi des paquets ---

# Reseau

## Lister les reseaux

	docker network ls

## Isoler un conteneur

	docker run --rm -it --network=non <image>

## Créer un reseau

	docker network create --driver=bridge <choisir nom de notre reseau>

## Créer un reseau avec une plage d'IP

	docker network create --driver=bridge --subnet=192.168.0.0/24 <choisir nom du reseau>

## Lister les reseaux

	docker network ls

## Créer un conteneur et le connecter direct a un reseau

	docker run -it --rm --network=<nom du reseau> --name=<choisir un nom de conteneur> <image>

## Connecter le 1er conteneur au 2eme qui ont les meme reseau

	"dans le 1er conteneur" ping <nom du conteneur 2>

## Créer et ensuite connecter des conteneurs a un resau

	Creer un conteneur sans le reseau
		docker run -it --name=<nom du reseau> <image>

	rester dans le terminal en dehors du conteneur
	puis faire cette commande

		docker network connect <nom du reseau> <nom du conteneur>

	faire la meme chose pour un autre conteneur avec le mm reseau

	ping <nom du conteneur destinataire>

## Verifier quel conteneur est relier au reseau

	docker network inspect <nom du reseau>

## Déconnecter les conteneurs du les reseaux

	docker network disconnect <nom du reseau> <nom du conteneur>

## Supprimer le reseau ou les reseaux

	docker network rm <nom du reseau> ...

# Dockerfile

## Créer une image personnalisee avec le fichier Dockerfile

...Dockerfile

	FROM alpine:3.19 permet de creer une image avec une image de base

	ensuite faire

	apt update 

	permet de faire la mise a jour
	puis installer les programmes que l'on veut

	apt install -y <nom du programme>


## Créer une image personnalisee a partir du Dockerfile

	... bash

		Construire l'image avec un nom

			docker build -t <choisir nom de l'image> <chemin du dosssier contenant le Dockerfile>

		ensuite on peut creer un  conteneur avec cette image

			docker run -it --rm <nom de l'image que l'on vient de creer>

## Ajouter l'image au DockerHUB

	aller sur le site docker hub et creer un compte et faire un repository

	sur le terminal : 

	docker tag <image> <repository>
	docker push <repository>

## Voir son login 

	docker login
		si pas connecter 
	aller sur le site https://login.docker.com/activate
	mettre les caracteres afficher dans le message du terminal
	une fois connecte refaire la commande

	docker push <repository>

# Docker-compose

## verifier et installer docker-compose

	- verifier si il existe dans notre terminal
		docker compose version 

	- Comment installer docker compose
		sudo apt update && apt install -y docker-compose-plugin
	
	- verification..
		docker compose version

## compose.yml simple

...docker-compose.yml

	services:
		<nom du service>:
			image: <image de base>
			container_name: <nom du conteneur>

## Lancer le compose.yml

...bash

	docker compose up

Lancer en arriere plan :

...bash

	docker compose up -d

## Interagir avec le conteneur

...docker-compose.yml

	services:
		<nom du service>:
			image: <image de base>
			container_name: <nom du conteneur>
			stdin_open: true
			tty: true
Ensuite utiliser la commande suivante

...bash 

	docker exec -it <id ou le nom du conteneur> bash

## Arreter un conteneur

...bash

	docker compose stop 

## Supprimer les conteneurs

...bash

	docker compose rm

## Volume Mappé

...docker-compose.yml

	services:
		<nom du service>:
			image: <image de base>
			container_name: <nom du conteneur>
			stdin_open: true
			tty: true
			volumes:
				- <chemin de dossier local>:<chemin du dossier du conteneur>

## Volume managé

...docker-compose.yml

		services:
		<nom du service>:
			image: <image de base>
			container_name: <nom du conteneur>
			stdin_open: true
			tty: true
			volumes:
				- <nom du volume>:<chemin du dossier du conteneur>

		volumes:
			<nom du volume>:

# Réseau

	Tous les conteneurs du compose.yml sont automatiquement connecte a un reseau

## Réseau personnalisée

...docker-compose.yml 

	services:
		<nom du service 1>:
			image: <image de base>
			container_name: <nom du conteneur 1>
			stdin_open: true //permet de garder actif le conteneur
			tty: true        //permet de garder actif le conteneur
			networks:
				-<nom du reseau>
	
		services:
		<nom du service 2>:
			image: <image de base>
			container_name: <nom du conteneur 2>
			stdin_open: true
			tty: true
			networks:
				-<nom du reseau>
			
	netwoks:
		<nom du reseau>:
			driver: bridge

# reseau bridge = docker0 : reseau par defaut de docker, tous les conteneurs sont connectes a ce reseau

	comment le visualiser

	via local	ip a // ifconfig
	via docker	docker network ls
				docker inspect <id du bridge>
	
	pour installer ifconfig faire commande 
			sudo update && apt install -y iputils-ping net-tools


# USER

## Commande pour connaitre l'utilisateur actif
	whoami

## Créer un utilisateur

### Dans bash

	useradd -u 1111 jessi
	useradd -u <UID>  <choisir un nom user>

### Dans le Dockerfile 

	FROM: debian
	RUN useradd -u 1111 jessi

## Créer un conteneur avec le dockerfile

	docker build -t <choisir nom de l'image>:<version>  <chemin du dockerfile>

## Créer un repertoire sur ton systeme hôte, et non dans le projet

	mkdir /<nom du volume>/
	
## Lancer ce conteneur avec le volume sans utilisateur

	docker run -d --name <choisir un nom de conteneur> -v /<nom du volume>/:<chemin du reperoire qui est dans le conteneur et sera lier au volume> <image>

## Pour que le conteneur reste actif 

	docker run -d --name <choisir un nom de conteneur> -v /<nom du volume>/:<chemin du reperoire qui est dans le conteneur et sera lier au volume> <image>
	sleep infinity

## Comment savoir quel droit et utilisateur ont acces a nos fichier et peuvent modifier

	ls -la /myvolume/

## Lancer ce conteneur avec le volume AVEC utilisateur

	docker run -d --name <choisir un nom de conteneur> -v /<nom du volume>/:<chemin du reperoire qui est dans le conteneur et sera lier au volume> 
	-u <nom qui a etait choisi dans le dockerfile> <image> sleep infinity

## Se connecter au conteneur avec le nom utlisateur

	docker exec -it <nom du conteneur> bash

## Donner les permissions a l'utilisateur 

	chown <nom de l'ulisateur> <nom du volume / repertoire>

## Connaitre si l'id existe ou pas 

	id <nom de l'utilisateur>