FROM python

RUN set -x \
    && echo "Installing system dependencies..." \
    && apk add --no-cache supervisor nginx python3-dev build-base linux-headers pcre-dev \
    && pip install uwsgi \
    && echo "Cleaning up..." \
    && rm -r /root/.cache \
    && apk del --no-cache python3-dev build-base linux-headers pcre-dev

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.uwsgi.conf /etc/nginx/conf.d/default.conf
COPY uwsgi.ini /etc/uwsgi/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /start.sh
COPY app /app

WORKDIR /app

RUN set -x \
    && echo "Setting up system..." \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && chmod +x /start.sh

VOLUME [ "/app" ]

EXPOSE 80

STOPSIGNAL SIGTERM

CMD [ "/start.sh" ]
