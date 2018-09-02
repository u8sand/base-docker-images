FROM mysql

RUN set -x \
    && echo "Installing system dependencies..." \
    && apk add --no-cache mysql

COPY entrypoint.sh /entrypoint.sh

RUN set -x \
    && echo "Setting up system..." \
    && chmod +x /entrypoint.sh

ENV MYSQL_ROOT_PASSWORD $MYSQL_ROOT_PASSWORD
ENV MYSQL_USERNAME $MYSQL_USERNAME
ENV MYSQL_PASSWORD $MYSQL_PASSWORD
ENV MYSQL_DATABASE $MYSQL_DATABASE

VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

STOPSIGNAL SIGTERM

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "mysqld", "--user=mysql" ]
