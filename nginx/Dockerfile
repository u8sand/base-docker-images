FROM base

RUN set -x \
  && echo "Installing system dependencies..." \
  && apk add --no-cache nginx

COPY html /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.default.conf /etc/nginx/conf.d/default.conf

RUN set -x \
  && echo "Setting up system..." \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

STOPSIGNAL SIGTERM

VOLUME [ "/usr/share/nginx/" ]

CMD [ "nginx" ]
