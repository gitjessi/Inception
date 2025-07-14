#!/bin/bash

set -e

# Création du dossier /run/php si absent
mkdir -p /run/php

# Attente de la base de données MariaDB
echo "⏳ Attente de MariaDB..."
until mysqladmin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
  echo "🔄 En attente de MariaDB à l'adresse $MYSQL_HOST..."
  sleep 2
done

# Vérifie si wp-config.php existe déjà
if [ ! -f /var/www/wordpress/wp-config.php ]; then
  echo "📄 Création de wp-config.php..."
  wp config create \
    --dbname="$MYSQL_DATABASE" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$MYSQL_PASSWORD" \
    --dbhost="$MYSQL_HOST":3306 \
    --path='/var/www/wordpress' \
    --allow-root

  echo "⚙️ Installation de WordPress..."
  wp core install --allow-root \
    --url="$WORDPRESS_URL" \
    --title="$WORDPRESS_TITLE" \
    --admin_user="$WORDPRESS_ADMIN_USER" \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
    --path='/var/www/wordpress'

  # Créer un deuxième utilisateur si pas encore existant
  if ! wp user get "$WORDPRESS_USER" --path='/var/www/wordpress' --allow-root > /dev/null 2>&1; then
    wp user create --allow-root "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
      --role=author --user_pass="$WORDPRESS_USER_PASSWORD" \
      --path='/var/www/wordpress'
    echo "✅ Utilisateur $WORDPRESS_USER créé."
  else
    echo "ℹ️ Utilisateur $WORDPRESS_USER existe déjà."
  fi
else
  echo "✅ wp-config.php déjà présent, on ne le recrée pas."
fi

# Création du dossier /run/php si absent (évite erreur PHP-FPM)
mkdir -p /run/php

# Lancement de PHP-FPM au premier plan
exec /usr/sbin/php-fpm7.4 -F
