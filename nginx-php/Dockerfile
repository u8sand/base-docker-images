FROM nginx

RUN set -x \
  && echo "Installing system dependencies..." \
  && apk add --no-cache supervisor php5-fpm

COPY nginx.php.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /start.sh
COPY app /app

WORKDIR /app

VOLUME [ "/app" ]

EXPOSE 80
STOPSIGNAL SIGTERM

CMD [ "/start.sh" ]
