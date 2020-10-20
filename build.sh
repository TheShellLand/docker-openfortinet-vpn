#!/usr/bin/env bash

# build docker image

cd $(dirname $0)

DOCKERFILE="Dockerfile"
DOCKERNAME=theshellland/docker-openfortinet-vpn
DOCKERTAG=$(git describe --tags --always)


if [ ! -f "$DOCKERFILE" ]; then echo "*** $DOCKERFILE not found ***"; exit 1; fi
if [ ! $(which docker) ]; then echo "*** please install docker ***"; exit 1; fi


# create required files
if [ ! -f user_mods.sh ]; then
  cp user_mods.sh.example user_mods.sh
fi

set -ex

# build image
docker build $@ -t $DOCKERNAME:$DOCKERTAG -f $DOCKERFILE .
docker tag $DOCKERNAME:$DOCKERTAG $DOCKERNAME:latest

# list image
docker images | grep $DOCKERNAME
