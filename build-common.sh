#! /bin/bash

YELLOW=$(tput setaf 3)
readonly YELLOW
NC=$(tput sgr0)
readonly NC

readonly BACKUP_FILE=".dazzle.yaml.orig"
readonly ORIGINAL_FILE="dazzle.yaml"

function save_original() {
	if [ ! -f ${BACKUP_FILE} ]; then
		echo "${YELLOW}Creating a backup of ${ORIGINAL_FILE} as it does not exist yet...${NC}" && cp ${ORIGINAL_FILE} ${BACKUP_FILE}
	fi
}

function restore_original() {
	echo "${YELLOW}Restoring backup file ${BACKUP_FILE} to original file ${ORIGINAL_FILE}${NC}"
	cp ${BACKUP_FILE} ${ORIGINAL_FILE}
}

function ctrl_c() {
	echo "${YELLOW}** Trapped CTRL-C${NC}"
	restore_original
}

function get_available_chunks() {
	local chunk_defs
	chunk_defs=$(ls chunks)
	for chunk in $chunk_defs; do
		local chunkYaml="chunks/${chunk}/chunk.yaml"
		if [[ -f "$chunkYaml" ]]; then
			variants=$(yq e '.variants[].name' "$chunkYaml")
			for variant in $variants; do
				echo "$chunk:$variant"
			done
		else
			echo "$chunk"
		fi

	done
}
