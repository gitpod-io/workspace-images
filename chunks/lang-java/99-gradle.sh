#!/bin/bash

# This script calculates the optimal number of Gradle workers for a Gitpod workspace.
# It uses `gp top` to detect the number of available virtual CPUs, as Gitpod workspaces run in containers
# and only a subset of the CPU cores known to the Linux kernel are usable.

# Gitpod Cloud:
# If a workspace is described as "up to X cores", dynamic CPU limiting is active.
# The script takes the number of cores from the description and divides it by two, since .resources.cpu.limit
# represents the current limit and depends on CPU utilization.

# Gitpod Enterprise:
# The script uses the value of .resources.cpu.limit, which represents the static CPU limit.

# In any case, the number of workers is set to (core - 2) to leave some capacity for IDE backend processes.

json=$(gp top --json)
description=$(echo "$json" | jq -r '.workspace_class.description')
upto=$(echo "$description" | grep -oP '(?<=Up to )\d+(?= cores)' || echo "")
limit=$(echo "$json" | jq '.resources.cpu.limit / 1000')

if [[ -z "$upto" ]]; then
	vcpus=$((limit))
else
	vcpus=$((upto / 2))
fi

# Leave 2 vCPUs for other processes, such as IDE backends
workers=$((vcpus - 2))

# Ensure at least one worker, even in small workspaces
workers=$((workers < 1 ? 1 : workers))

# Set an environment variable to configure Gradle
export GRADLE_OPTS="-Dorg.gradle.workers.max=$workers"

# Output the configuration details
# printf "upto: $upto\nlimit: $limit\nvcpu: $vcpus\nworkers: $workers\nGRADLE_OPTS=$GRADLE_OPTS\n"
