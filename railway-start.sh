#!/bin/sh
# Start script for Adminer on Railway.
# - Prepares the /data volume (Railway mounts it owned by root) for the adminer user:
#   /data/sessions holds PHP sessions, /data/tmp holds adminer.key (encrypts "permanent
#   login" passwords) and the failed-login log, so all of them survive a redeploy.
# - Drops root and runs the image's own entrypoint and the PHP server on $PORT.
set -e

export PORT="${PORT:-8080}"
mkdir -p /data/sessions /data/tmp
chown adminer:adminer /data /data/sessions /data/tmp
chmod 700 /data/sessions /data/tmp

# su -p keeps the environment (PORT, ADMINER_*); the command is a fixed string, so no
# argument of PHP's can be read as an option of su.
cd /var/www/html
exec su -p -s /bin/sh adminer -c \
  'exec entrypoint.sh docker-php-entrypoint php -S "[::]:${PORT}" -t /var/www/html'
