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