#!/bin/bash
# author: natefoo
# https://github.com/galaxyproject/infrastructure-playbook/blob/ef9f31a4d23c5e12c48189f08cea521d16b7f6ff/files/slurm/epilog.sh#L4

set -o posix
set -o nounset
set -o errexit
set -o pipefail

[ -n "$SLURM_JOB_ID" ] || { echo "No job id!"; exit 0; }

(
workdir=$(scontrol show job "$SLURM_JOB_ID" | sed 's/.*\( \|^\)WorkDir=\([^ ]*\)\( \|$\).*/\2/p;d')
container_config="${workdir}/../configs/container_config.json"

if [ -d "$workdir" -a -f "$container_config" ]; then
    container_id=$(jq -r '.container_name'  "$container_config")
    docker kill "$container_id"
fi
) 2>&1 >/dev/null || true #>/tmp/epilog."$SLURM_JOB_ID"

exit 0
