#!/usr/bin/env sh

PORT=8888
IPADDR="0.0.0.0"
PASSWORD_HASH=$(python -c \
  "from notebook.auth import passwd; \
   print(passwd('${PASSWORD}'))")

jupyter notebook \
  --allow-root \
  --no-browser \
  --ip=${IPADDR} \
  --port=${PORT} \
  --NotebookApp.password=${PASSWORD_HASH} \
  $@
