#!/bin/bash

DOCKER_FILE="Dockerfile"
DOCKER_TAG="jwkaguya/torchserve-kfs:latest-gpu"
BASE_IMAGE="jwkaguya/torchserve:latest-gpu"
NO_CACHE=false

for arg in "$@"
do
    case $arg in
        -h|--help)
          echo "options:"
          echo "-h, --help  show brief help"
          # echo "-g, --gpu specify for gpu build"
          echo "-t, --tag specify tag name for docker image"
          exit 0
          ;;
        # -g|--gpu)
        #   DOCKER_TAG="pytorch/torchserve-kfs:latest-gpu"
        #   BASE_IMAGE="pytorch/torchserve:latest-gpu"
        #   shift
        #   ;;
        -d|--dev)
          DOCKER_FILE="Dockerfile.dev"
          shift
          ;;
        -t|--tag)
          DOCKER_TAG="$2"
          shift
          shift
          ;;
        -nc|--no-cache)
          NO_CACHE=true
          shift
          ;;
    esac
done

cp ../../frontend/server/src/main/resources/proto/*.proto .

BUILD_COMMAND="DOCKER_BUILDKIT=1 docker build --file $DOCKER_FILE --build-arg BASE_IMAGE=$BASE_IMAGE -t $DOCKER_TAG ."
if [ "${NO_CACHE}" == "true" ]; then
  BUILD_COMMAND="$BUILD_COMMAND --pull --no-cache"
fi
echo $BUILD_COMMAND
eval $BUILD_COMMAND
