#!/usr/bin/env bash

set -Eeuo pipefail

CURR_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
ZIPPED="/to_docker.zip"
OUTPUT="/to_docker"
cd $CURR_DIR

if [ -d "$CURR_DIR$OUTPUT" ]; then
    rm -r $CURR_DIR$OUTPUT
    unzip $CURR_DIR$ZIPPED
else 
    unzip $CURR_DIR$ZIPPED
fi
