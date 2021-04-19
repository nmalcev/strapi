#!/usr/bin/env bash

OPTION=$1
COMMAND=$2

if [[ "$OPTION" == "sqlite" ]]; then
    YML_PATH="./docker-compose.sqlite.yml"
else
    YML_PATH="./docker-compose.postgres.yml"
fi

if [[ "$COMMAND" == "down" ]]; then
    DC_CMD="down"
elif [[ "$COMMAND" == "up" ]]; then
    DC_CMD="up --build"
elif [[ "$COMMAND" == "ps" ]]; then
    DC_CMD="ps"
elif [[ "$COMMAND" == "logs" ]]; then
    DC_CMD="logs"
fi

sh -c "docker-compose -f $YML_PATH $DC_CMD"
