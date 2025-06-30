#permet de creer une image personnalisee de MariaDB

FROM alpine:3.19

# installation de la base de données MariaDB
RUN apk update && apk add --no-cache mariadb mariadb-client

# Copier fichier de configuration si besoin
COPY ./conf/my.cnf /etc/mysql/my.cnf

# Créer les dossiers nécessaires et permissions
RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

EXPOSE 3306

USER mysql

CMD ["mysqld"]


# creer un groupe utilisateur qui peuvent modifier la base de données

#RUN groupadd appgroup \
# && useradd -u 1111 -g appgroup jessi \   //ajout d'un utilisateur jessi
# && mkdir /data \     // creation du dossier data
# && chown root:appgroup /data \    // attribution du groupe appgroup au dossier data
# && chmod 770 /data #    // attribution des droits d'écriture et de lecture au groupe appgroup