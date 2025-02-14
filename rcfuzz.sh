#!/bin/bash -e

# /work/rcfuzz can be anything
# rcfuzz.sh run --rm -v data:/work/rcfuzz -w /work/rcfuzz rcfuzz

SCRIPT_DIR=$(dirname $(realpath $0))

COMPOSE_FILE=$SCRIPT_DIR/docker-compose.yml

JOBS=${JOBS:=1}

echo "JOBS is ${JOBS}"

docker-compose -f $COMPOSE_FILE "$@"
