#!/bin/bash
set -euo pipefail
trap ctrl_c EXIT

# shellcheck source=/dev/null
source build-common.sh

readonly TEMP_FILE=".dazzle.yaml.temp"
readonly REPO="localhost:5000/dazzle"

function usage() {
	cat <<EOF
Usage: ./build-chunk.sh [OPTION]...
Example: ./build-chunk.sh -c lang-c -c dep-cacert-update -c lang-go:1.17.5
Options for build:
  -h, --help      Display this help
  -c, --chunk     Chunk to build, You can build multiple chunks: -c chunk1 -c chunk2. If no chunks are supplied then build using existing config
EOF
}

function build_chunks() {
	dazzle build ${REPO} -v --chunked-without-hash && dazzle build ${REPO} -v
}

function extract_variants() {
	local chunk_name=${1}
	shift 1
	local variants=""

	if [[ ! -f "chunks/${chunk_name}/chunk.yaml" ]]; then
		variants+=("${chunk_name}")
	else
		for variant in $(yq '.variants[].name' -r <"chunks/${chunk_name}/chunk.yaml"); do
			variants+=("${chunk_name}:${variant}")
		done
	fi
	echo "${variants[*]}"
}

ARGS=$(getopt -o h,:c:n: --long help:,chunk:,name: -- "$@")
eval set -- "${ARGS}"

save_original

CHUNKS=""

while true; do
	case "$1" in
	-h | --help)
		usage
		exit 0
		;;
	-c | --chunk)
		# if CHUNKS is empty then assign current value
		if [[ -z "${CHUNKS}" ]]; then
			CHUNKS="$2"
		else
			# else append
			CHUNKS+=("$2")
		fi
		shift 2
		;;
	--)
		shift
		break
		;;
	*)
		echo Error: unknown flag "$1"
		echo "${YELLOW}Run 'build-chunk.sh --help' for usage.${NC}"
		exit 1
		;;
	esac
done

# if no chunks specified then build using existing dazzle.yaml
if [[ -z "${CHUNKS[*]}" ]]; then
	echo "${YELLOW}No chunks specified, will build using the existing ${ORIGINAL_FILE}${NC}"
else
	# else build for supplied arguments
	[ -f "${ORIGINAL_FILE}" ] && echo "${YELLOW}Deleting ${ORIGINAL_FILE}, will produce a new config with supplied arguments${NC}" && rm "${ORIGINAL_FILE}"

	for CN in $(get_available_chunks); do
		if [[ ! ${CHUNKS[*]} =~ ${CN} ]]; then
			dazzle project ignore "${CN}"
		else
			VARIANTS=$(extract_variants "${CN}")
			for VARIANT in ${VARIANTS}; do
				CHUNKS_TO_COMBINE+=("${VARIANT}")
			done
		fi
	done

	# dazzle project add-combination "${COMBINATION}" "${CHUNKS_TO_COMBINE[@]}"
fi

build_chunks

echo "${YELLOW}Saving dazzle config used to generate build in ${TEMP_FILE}${NC}"
cp "${ORIGINAL_FILE}" ${TEMP_FILE}
