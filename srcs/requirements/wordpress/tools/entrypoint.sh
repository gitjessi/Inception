
#!/bin/bash
set -e

sleep 10

# Créer wp-config.php si non présent
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "📄 Création de wp-config.php..."
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost=mariadb:3306 --path='/var/www/wordpress' \
        --allow-root
fi

  # Installe WordPress (site, admin user, etc)
  wp core install --allow-root \
    --url="$WORDPRESS_URL" \
    --title="$WORDPRESS_TITLE" \
    --admin_user="$WORDPRESS_ADMIN_USER" \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
    --path='/var/www/wordpress'

  # Crée un deuxième utilisateur WordPress si besoin
  wp user create --allow-root "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
    --role=author --user_pass="$WORDPRESS_USER_PASSWORD" \
    --path='/var/www/wordpress'

  echo "Configuration WordPress terminée."
else
  echo "wp-config.php existe déjà, on ne touche pas."
fi

# Création du dossier /run/php si absent (évite erreur PHP-FPM)
mkdir -p /run/php

# Lancement de PHP-FPM au premier plan
exec /usr/sbin/php-fpm7.3 -F
