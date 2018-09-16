#!/bin/bash

DOMAIN=u8sand

TYPE=""
PUSH=0
SAVE=0

while getopts ":t:ps" opt; do
  case $opt in
    t)
      TYPE="$OPTARG"
      ;;
    p)
      PUSH=1
      ;;
    s)
      SAVE=1
      ;;
    [\?:])
      echo "Usage: $(basename $0) (-t TYPE) (-p) (-s)"
      echo "  -t  type of Dockerfile to build (Dockerfile.TYPE)"
      echo "  -p  push built docker images"
      echo "  -s  save built docker images"
      exit 1
      ;;
  esac
done

get_file() {
	IMG=$1
	TYPE=$2

  if [ ! -z "$TYPE" -a -f "$IMG/Dockerfile.$TYPE" ]; then
    echo "$IMG/Dockerfile.$TYPE"
  else
    echo "$IMG/Dockerfile"
  fi
}

make_file() {
	IMG=$1
	TYPE=$2
  FILE=$(get_file $IMG $TYPE)

  if [ "$IMG" != "base" ]; then
    sed "s:FROM \\(.*\\)$:FROM $DOMAIN/\1:g" $FILE
  else
    cat $FILE
  fi
}

for IMG in */; do
    awk "/^FROM/{print \$2\" $(basename $IMG)\"}" $(get_file "$IMG" "$TYPE")
done | tsort | while read IMG; do
  if [ -d $IMG ]; then
    echo "Bulding $IMG..."
    make_file "$IMG" "$TYPE" | docker build -f - -t $DOMAIN/$IMG $IMG
    if [ $? -ne 0 ]; then
      echo "Failed to build $IMG!"
      exit 1
    fi
    if [ $PUSH -ne 0 ]; then
      echo "Pushing $DOMAIN/$IMG..."
      docker push $DOMAIN/$IMG
      if [ $? -ne 0 ]; then
        echo "Failed to push $DOMAIN/$IMG!"
        exit 1
      fi
    fi
    if [ $SAVE -ne 0 ]; then
      echo "Saving $IMG..."
      docker save -o $IMG.tar $DOMAIN/$IMG
      if [ $? -ne 0 ]; then
        echo "Failed to save $IMG!"
        exit 1
      fi
    fi
  else
    echo "Skipping $IMG..."
  fi
done
