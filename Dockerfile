# Adminer for Railway: the official image, pinned by version and digest, plus a small wrapper.
FROM adminer:6.3.0-standalone@sha256:7605e298e5a2ac74d806283362fa253a4e0a42cfd881e8fa2c155f0631899f6c

USER root

# PHP settings for Railway: sessions, adminer.key and the failed-login log live on the
# /data volume; Secure cookies behind Railway's HTTPS edge; room for SQL imports.
COPY railway.ini /usr/local/etc/php/conf.d/zz-railway.ini
COPY railway-prepend.php /usr/local/etc/php/railway-prepend.php
COPY railway-start.sh /usr/local/bin/railway-start.sh

# Group failed logins by the real client address. Behind Railway's proxy every request
# comes from the proxy's address, so without this plugin 30 failed logins by anyone would
# lock everyone out for 30 minutes (upstream login-reverse-proxy plugin).
RUN chmod 755 /usr/local/bin/railway-start.sh \
 && php plugin-loader.php login-reverse-proxy > plugins-enabled/000-login-reverse-proxy.php \
 && chown adminer:adminer plugins-enabled/000-login-reverse-proxy.php

ENV PORT=8080 \
    PHP_CLI_SERVER_WORKERS=4 \
    ADMINER_DEFAULT_SERVER=postgres.railway.internal

EXPOSE 8080
# The image's entrypoint (ADMINER_DESIGN, ADMINER_PLUGINS) stays and runs after the start
# script has prepared /data and dropped to the unprivileged adminer user.
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
CMD []
