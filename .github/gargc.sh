#!/bin/bash

# Inspired from https://gist.github.com/ahmetb/7ce6d741bd5baa194a3fac6b1fec8bb7

IFS=$'\n\t'
set -eou pipefail

if [[ "$#" -ne 2 || "${1}" == '-h' || "${1}" == '--help' ]]; then
	cat >&2 <<"EOF"
gargc.sh cleans up tagged or untagged images pushed before specified date
for a given image
USAGE:
  gargc.sh REPOSITORY DATE
EXAMPLE
  gargc.sh  europe-docker.pkg.dev/gitpod-artifacts/docker-dev-pr/workspace-base-images-pr 2017-04-01
  would clean up all images tags pushed before 2017-04-01 (i.e. < 2017-04-01 ) for
  europe-docker.pkg.dev/gitpod-artifacts/docker-dev-pr/workspace-base-images-pr image.
EOF
	exit 1
elif [[ "${#2}" -ne 10 ]]; then
	echo "wrong DATE format; use YYYY-MM-DD." >&2
	exit 1
fi

main() {
	local C=0
	IMAGE="${1}"
	DATE="${2}"
	for digest in $(gcloud artifacts docker images list "${IMAGE}" --limit=999999 \
		--filter="updateTime<${DATE}" --format='value(version)'); do
		(
			gcloud artifacts docker images delete "${IMAGE}@${digest}" --delete-tags --quiet
		)
		((C++)) || true
	done
	echo "Deleted ${C} images in ${IMAGE}." >&2
}

main "${1}" "${2}"
