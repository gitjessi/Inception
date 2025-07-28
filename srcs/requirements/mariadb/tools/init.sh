#!/bin/sh

set -e

if [ ! -d /var/lib/mysql/mysql ]; then
  echo "Initialisation de la base de donnees..."
  mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql > /dev/null

  # Création du fichier SQL d'initialisation
  cat > init.sql << EOF
FLUSH PRIVILEGES;
EOF

  if [ -n "$MYSQL_DATABASE" ]; then
    echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;" >> init.sql
    echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> init.sql
    echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';" >> init.sql
    echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';" >> init.sql
    echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'localhost';" >> init.sql
  fi

  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" >> init.sql
  echo "FLUSH PRIVILEGES;" >> init.sql

  # Lancement de mysqld en mode bootstrap pour exécuter le fichier SQL
  mysqld --user=mysql --bootstrap < init.sql

  rm init.sql
fi

exec mysqld --user=mysql --console