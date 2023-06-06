#!/usr/bin/env bash
#set -Eeuo pipefail

set -e 

CURR_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
CSV="/20220216-20230420.csv"
R_SCRIPT="/epiNowDockerTemplate.R"
R_SCRIPT_OUTPUT="/epiNowDocker.R"
RUN_SCRIPT="/run_epinow_docker.sh"
RUN_SCRIPT_TEST="/run_epinow_docker_test.sh"
DATA_DIR="/output"
SRC="to_docker"
ZIPPED=$CURR_DIR"/to_docker.zip"
OUT_DIR=$CURR_DIR"/to_docker"
UNZIPPER=$CURR_DIR"/unzip.sh"
TARGET_DIR="/home/rstudio/"

if [ -d "$OUT_DIR" ]; then
    rm -r $OUT_DIR
    mkdir $OUT_DIR
else 
    mkdir $OUT_DIR
fi

echo "data_file = '.$CSV'" > $OUT_DIR'/epiNowDocker.txt'
cat $CURR_DIR$R_SCRIPT >> $OUT_DIR'/epiNowDocker.txt'
mv $OUT_DIR'/epiNowDocker.txt' $OUT_DIR'/epiNowDocker.R'
cp $CURR_DIR$DATA_DIR$CSV $OUT_DIR$CSV
cp $CURR_DIR$RUN_SCRIPT $OUT_DIR$RUN_SCRIPT

if [ -f "$ZIPPED" ]; then
    rm "$ZIPPED"
    zip "$ZIPPED" -r "$SRC"
else 
    zip "$ZIPPED" -r "$SRC"
fi

docker cp $ZIPPED 'epinow2':/home
rm "$ZIPPED"
rm -r "$OUT_DIR"
docker cp $UNZIPPER 'epinow2':/home
docker exec epinow2 /home/unzip.sh
docker exec epinow2 bash -c "mv /home/to_docker$CSV /home/rstudio$CSV";
docker exec epinow2 bash -c "mv /home/to_docker$R_SCRIPT_OUTPUT /home/rstudio$R_SCRIPT_OUTPUT";
#docker exec epinow2 bash -c "mv /home/to_docker$RUN_SCRIPT_TEST /home/rstudio$RUN_SCRIPT_TEST";
docker exec epinow2 bash -c "mv /home/to_docker$RUN_SCRIPT /home/rstudio$RUN_SCRIPT";

docker logs -f epinow2 |tee epinow_docker2.log & # tail -f /home/mark/code/nsw-epiNow2/epinow_docker.log

#docker exec epinow2 /home/rstudio$RUN_SCRIPT_TEST