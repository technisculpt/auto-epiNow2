#!/usr/bin/env bash

set -Eeuo pipefail

STDOUT="/proc/1/fd/1"

echo "begninning R script" > STDOUT
echo $(date +%s) > $STDOUT

Rscript /home/to_docker/epiNowDocker.R > STDOUT

echo "begninning R script" > STDOUT
echo $(date +%s) > $STDOUT