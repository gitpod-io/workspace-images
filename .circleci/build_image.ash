#!/bin/ash
# This is expected to be invoked on busybox's ash

###! FIXME-DOCS: Intro
###! Abstract:
###! - We are expecting to build dockerimage by providing 'IMAGE_NAME' and "DOCKERFILE" that are then expanded in 'docker build -t $IMAGE_NAME -f $DOCKERFILE $DIR'
###! - Process DOCKER_USER

set -xe

# Assertion helper
die() {
	# Allow specifying exit code
	case "$1" in
		1) printf 'FATAL: %s\n' "$2"
		2) printf 'Syntax error: %s\n' "$2"
		255) printf 'FATAL: Unexpected happend while %s\n' "$2"
		*) exit 255
	esac

	# Exit
	exit "$1"
}

build-image() {
	DOCKERFILE="$1"
	IMAGE_NAME="$2"

	# CORE
	docker build -t $IMAGE_NAME -f $DOCKERFILE "$(dirname "$1")" || die 1 "Unable to build image '$IMAGE_NAME' with dockerfile '$DOCKERFILE'"

	if [ ! -z $DOCKER_USER ]; then
		# Log in to Docker Hub.
		# Use heredoc to avoid variable getting exposed in trace output.
		# Use << (<<< herestring is not available in busybox ash).
		docker login -u $DOCKER_USER --password-stdin << EOF
			$DOCKER_PASS
		EOF
  if [[ $CIRCLE_BRANCH != "master" ]]; then
    # Work in progress: Tag the image ":branch-X" and push it to Docker Hub.
    DOCKERHUB_TAG="branch-$(echo $CIRCLE_BRANCH | sed 's_/_-_g')"
    docker tag $IMAGE_NAME $IMAGE_NAME:$DOCKERHUB_TAG
    docker push $IMAGE_NAME:$DOCKERHUB_TAG
  else
    # Production release: Tag the image ":latest" and push it to Docker Hub.
    docker tag $IMAGE_NAME $IMAGE_NAME:latest
    docker push $IMAGE_NAME:latest
    # Also tag it ":commit-Y" for future reference.
    DOCKERHUB_TAG="commit-$CIRCLE_SHA1"
    docker tag $IMAGE_NAME $IMAGE_NAME:$DOCKERHUB_TAG
    docker push $IMAGE_NAME:$DOCKERHUB_TAG
  fi
fi
}


# Process arguments
while [ "$#" -ge 1 ]; do case "$1" in
	*[a-z]*) build-image ;;
	*) die 2 "Invalid argument '$1' has been parsed"
esac; done

# --- Original code below

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 DOCKERFILE IMAGE_NAME"
  exit 2
fi

docker build -t $IMAGE_NAME -f $DOCKERFILE $DIR

if [[ ! -z $DOCKER_USER ]]; then
  # Log in to Docker Hub.
  # Use heredoc to avoid variable getting exposed in trace output.
  # Use << (<<< herestring is not available in busybox ash).
  docker login -u $DOCKER_USER --password-stdin << EOF
$DOCKER_PASS
EOF
  if [[ $CIRCLE_BRANCH != "master" ]]; then
    # Work in progress: Tag the image ":branch-X" and push it to Docker Hub.
    DOCKERHUB_TAG="branch-$(echo $CIRCLE_BRANCH | sed 's_/_-_g')"
    docker tag $IMAGE_NAME $IMAGE_NAME:$DOCKERHUB_TAG
    docker push $IMAGE_NAME:$DOCKERHUB_TAG
  else
    # Production release: Tag the image ":latest" and push it to Docker Hub.
    docker tag $IMAGE_NAME $IMAGE_NAME:latest
    docker push $IMAGE_NAME:latest
    # Also tag it ":commit-Y" for future reference.
    DOCKERHUB_TAG="commit-$CIRCLE_SHA1"
    docker tag $IMAGE_NAME $IMAGE_NAME:$DOCKERHUB_TAG
    docker push $IMAGE_NAME:$DOCKERHUB_TAG
  fi
fi
