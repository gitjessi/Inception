
# Dockerfile

FROM python:slim-bullseye // utilise l'image python slim-bullseye comme base

LABEL VERSION=V1.0.0  // version de l'image
LABEL app="xavki-app" // nom de l'application
ENV FLASK_APP=app.py // nom du fichier principal de l'application Flask
ENV FLASK_ENV=dev // mode de l'application Flask (dev, prod, etc.)

WORKDIR /app // le conteneur demarre dans le dossier app
COPY . .  // copie le contenu du dossier courant dans le conteneur

RUN pip3 install -r requirements.txt // installe les dependances du fichier requirements.txt
EXPOSE 5000 // expose le port 5000 pour que l'application soit accessible depuis l'exterieur du conteneur
CMD ["flask", "run", "--host=0.0.0.0"] // lance l'application Flask en ecoutant sur toutes les interfaces reseau