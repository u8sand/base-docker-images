#!/usr/bin/env sh

if [ ! -d /var/lib/mysql -o ! "$(ls -A /var/lib/mysql)" ]; then
  echo "Setting up mysql..."
  mysql_install_db --user=mysql

  echo "Starting up mysqld_safe..."
  mysqld_safe --user=mysql &
  MYSQL_SAFE_PID=$!

  echo "Waiting for database to respond..."
  while ! mysqladmin ping --silent; do
    sleep 1;
  done

  if [ ! -z "${MYSQL_DATABASE}" ]; then
    echo "Creating database ${MYSQL_DATABASE}..."
    mysqladmin create ${MYSQL_DATABASE}
  fi

  if [ ! -z "${MYSQL_ROOT_PASSWORD}" ]; then
    echo "Setting root password..."
    mysqladmin password "${MYSQL_ROOT_PASSWORD}"
  fi

  if [ ! -z "${MYSQL_USERNAME}" -a ! -z "${MYSQL_PASSWORD}" ]; then
    echo "Creating user ${MYSQL_USERNAME}..."
    mysql -u root --password="${MYSQL_ROOT_PASSWORD}" << EOF
USE mysql;
CREATE USER '${MYSQL_USERNAME}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USERNAME}'@'%' WITH GRANT OPTION;
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF
  fi

  echo "Shutting down mysqld_safe..."
  mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

  echo "Waiting for mysqld_safe to shut down..."
  wait "${MYSQL_SAFE_PID}"
fi

$@ &
MYSQL_PID=$!

trap "kill -SIGQUIT ${MYSQL_PID}" TERM
wait ${MYSQL_PID}