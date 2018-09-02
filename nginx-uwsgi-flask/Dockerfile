FROM nginx-uwsgi

RUN set -x \
    && echo "Installing python dependencies..." \
    && pip install flask \
    && rm -r /root/.cache

COPY app /app
