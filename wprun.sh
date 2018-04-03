#!/bin/bash
echo "running script"

if [ ! -d "/var/www" ]; then
  mkdir -p /var/www
fi

chown -R www-data.www-data /var/www
chmod -R 775 /var/www

if [ ! -d "/var/www/.git" ]; then
  git clone "$GIT_REPO" /var/www
else
  git -C /var/www pull
fi

cp /usr/local/wp-config.php /var/www/html

echo "Starting SSH ..."
rc-service sshd start

echo "Starting Apache httpd -D FOREGROUND ..."
apachectl start -D FOREGROUND