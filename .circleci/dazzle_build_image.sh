#!/bin/sh
set -xe

if [[ $# -le 2 ]]; then
  echo "Usage: $0 DOCKERFILE IMAGE_NAME [TAR_FILENAME]"
  exit 2
fi

if [[ -z $DOCKER_USER ]]; then
  echo "DOCKER_USER is mandatory"
  exit 2
fi

DIR=`dirname $1`
DOCKERFILE=`basename $1`
IMAGE_NAME=$2
TAR_FILENAME=$PWD/$3

DOCKERHUB_TAG="branch-$(echo $CIRCLE_BRANCH | sed 's_/_-_g')"
BUILD_IMAGE_NAME=$IMAGE_NAME:build-$DOCKERHUB_TAG

# Log in to Docker Hub.
# Use heredoc to avoid variable getting exposed in trace output.
# Use << (<<< herestring is not available in busybox ash).
# We'll be pushing images using docker.io/gitpod thus must login accordingly
docker login -u $DOCKER_USER --password-stdin docker.io << EOF
$DOCKER_PASS
EOF

cd $DIR
dazzle build --repository gitpod/dazzle-wsfull-build --output-test-xml results.xml -t $BUILD_IMAGE_NAME -f $DOCKERFILE .

if [[ $CIRCLE_BRANCH != "master" ]]; then
  # Work in progress: Tag the image ":branch-X" and push it to Docker Hub.
  docker tag $BUILD_IMAGE_NAME $IMAGE_NAME:$DOCKERHUB_TAG
  docker push $IMAGE_NAME:$DOCKERHUB_TAG
else
  # Production release: Tag the image ":latest" and push it to Docker Hub.
  docker tag $BUILD_IMAGE_NAME $IMAGE_NAME:latest
  docker push $IMAGE_NAME:latest
  # Also tag it ":commit-Y" for future reference.
  DOCKERHUB_TAG="commit-$CIRCLE_SHA1"
  docker tag $BUILD_IMAGE_NAME $IMAGE_NAME:$DOCKERHUB_TAG
  docker push $IMAGE_NAME:$DOCKERHUB_TAG
fi

if [[ ! -z $TAR_FILENAME ]]; then
  echo "exporting $BUILD_IMAGE_NAME to $TAR_FILENAME"
  docker save $BUILD_IMAGE_NAME -o $TAR_FILENAME
fi