#!/bin/bash
set -euo pipefail
set +x

readonly BACKUP_FILE=".dazzle.yaml.orig"
readonly TEMP_FILE=".dazzle.yaml.temp"
readonly ORIGINAL_FILE="dazzle.yaml"
readonly AVAILABLE_CHUNKS=$(ls chunks/)
readonly REPO="localhost:5000/dazzle"

function usage() {
	cat <<EOF
Usage: dazzle-up.sh [OPTION]...
Options for build:
  -h, --help      Display this help
  -c, --chunk     Chunk to build, You can build multiple chunks: -c chunk1 -c chunk2
  -n, --name      Combination name
EOF
}

function build_all() {
	# # First, build chunks without hashes
	dazzle build $REPO -v --chunked-without-hash
	# # Second, build again, but with hashes
	dazzle build $REPO -v
	# # Third, create combinations of chunks
	dazzle combine $REPO --all -v

}

ARGS=$(getopt -o h,:c:n: --long help:,chunk:,name: -- "$@")
eval set -- "${ARGS}"

[ ! -f ${BACKUP_FILE} ] && echo "Creating a backup of dazzle.yaml as it does not exist yet..." && cp ${ORIGINAL_FILE} ${BACKUP_FILE}

CHUNKS=""
COMBINATION="default"

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
	-n | --name)
		COMBINATION="$2"
		shift 2
		;;
	--)
		shift
		break
		;;
	*)
		echo Error: unknown flag "$1"
		echo "Run 'dazzle-up.sh --help' for usage."
		exit 1
		;;
	esac
done

# branch off to default dazzle config build for all combination
[ -z "${CHUNKS}" ] && echo "no chunks specified, will build using the existing ${ORIGINAL_FILE}" && build_all && exit 0

# else build for supplied arguments

[ -f ${ORIGINAL_FILE} ] && echo "Deleting ${ORIGINAL_FILE}" && rm ${ORIGINAL_FILE}

for CN in ${AVAILABLE_CHUNKS}; do
	if [[ ! ${CHUNKS[@]} =~ ${CN} ]]; then
		dazzle project ignore ${CN}
	else
		VARIANTS=extract_variants
		for VARIANT in ${VARIANTS}; do
			CHUNKS_TO_COMBINE+=("${VARIANT}")
		done
	fi
done

dazzle project add-combination ${COMBINATION} "${CHUNKS_TO_COMBINE[@]}"

echo "Saving temperory generated dazzle config in ${TEMP_FILE}"
cp ${ORIGINAL_FILE} ${TEMP_FILE}

# add logic to handle sigterm ctrl+c
echo "Copying backup file to original location"
cp ${BACKUP_FILE} ${ORIGINAL_FILE}
