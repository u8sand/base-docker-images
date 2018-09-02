FROM python

RUN set -x \
  && echo "Installing system dependencies..." \
  && apk add --no-cache tini shadow python3-dev build-base \
  && pip install jupyter \
  && rm -r /root/.cache

COPY start.sh /start.sh

RUN set -x \
  && echo "Setting up system..." \
  && chmod +x /start.sh

EXPOSE 8888

ENTRYPOINT [ "/sbin/tini", "--" ]

ENV PASSWORD $PASSWORD

WORKDIR /root/

CMD [ "/start.sh" ]
