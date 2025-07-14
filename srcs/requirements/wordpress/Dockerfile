
FROM debian:bullseye

# Mise à jour des paquets
RUN apt-get update && apt-get upgrade -y

# Installation des paquets nécessaires
RUN apt-get install -y wget \
    php7.4 \
    php-fpm \
    php-mysql \
    mariadb-client \
    unzip \
    curl \
    less

# Téléchargement et extraction de WordPress
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www \
    && cd /var/www \
    && tar -xzf wordpress-6.0-fr_FR.tar.gz \
    && rm wordpress-6.0-fr_FR.tar.gz

# Donner les droits à root
RUN chown -R root:root /var/www/wordpress

# Configuration de PHP
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Installation de WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copie du script d'initialisation
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Dossier de travail
WORKDIR /var/www/wordpress

# Port exposé pour PHP-FPM
EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
