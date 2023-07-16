#!/bin/bash

set -eu

IMAGE_TAG=$1

echo "Uploading ${IMAGE_TAG} at $(date -u +'%Y-%m-%d %H:%M:%S')"

# upload timestamped image
sudo -E skopeo copy --format=oci --dest-oci-accept-uncompressed-layers --retry-times=2 \
	"docker://${GAR_IMAGE_REGISTRY}/gitpod-artifacts/docker-dev/workspace-base-images:${IMAGE_TAG}" \
	"docker://${GAR_IMAGE_REGISTRY}/gitpod-artifacts/docker-dev/workspace-${IMAGE_TAG}:${TIMESTAMP_TAG}"

# upload latest image
sudo -E skopeo copy --format=oci --dest-oci-accept-uncompressed-layers --retry-times=2 \
	"docker://${GAR_IMAGE_REGISTRY}/gitpod-artifacts/docker-dev/workspace-base-images:${IMAGE_TAG}" \
	"docker://${GAR_IMAGE_REGISTRY}/gitpod-artifacts/docker-dev/workspace-${IMAGE_TAG}:latest"
