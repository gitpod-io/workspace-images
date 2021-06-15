#!/bin/sh

set -e

if [ $# -ne 2 ]; then
  echo "Usage: $0 DOCKERFILE IMAGE_NAME"
  exit 2
fi

DIR=$(dirname "$1")
DOCKERFILE=$1
IMAGE_NAME=$2

docker build -t "$IMAGE_NAME" -f "$DOCKERFILE" "$DIR"

if [ -n "$DOCKER_USER" ]; then
  # Log in to Docker Hub.
  # Use heredoc to avoid variable getting exposed in trace output.
  # Use << (<<< herestring is not available in busybox ash).
  docker login -u "$DOCKER_USER" --password-stdin << EOF
$DOCKER_PASS
EOF
  if [ "$CIRCLE_BRANCH" != "master" ]; then
    # Work in progress: Tag the image ":branch-X" and push it to Docker Hub.
    # shellcheck disable=SC2001
    DOCKERHUB_TAG="branch-$(echo "$CIRCLE_BRANCH" | sed 's_/_-_g')"
    docker tag "$IMAGE_NAME" "$IMAGE_NAME":"$DOCKERHUB_TAG"
    docker push "$IMAGE_NAME":"$DOCKERHUB_TAG"
  else
    # Production release: Tag the image ":latest" and push it to Docker Hub.
    docker tag "$IMAGE_NAME" "$IMAGE_NAME:latest"
    docker push "$IMAGE_NAME:latest"
    # Also tag it ":commit-Y" for future reference.
    DOCKERHUB_TAG="commit-$CIRCLE_SHA1"
    docker tag "$IMAGE_NAME" "$IMAGE_NAME:$DOCKERHUB_TAG"
    docker push "$IMAGE_NAME:$DOCKERHUB_TAG"
  fi
fi
