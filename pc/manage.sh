#!/usr/bin/env bash
source misc/common.sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )"


DC_FLAG="--file $DIR/docker-compose.yaml --env-file=$DIR/.env"

case $1 in
	'up')
		start;;
	'help')
		help;;
	'connect')
		connect;;
	'up')
		up $DC_FLAG;;
	'down')
		down $DC_FLAG;;
	'config')
		config $DC_FLAG;;
	*)
	help;;
esac
