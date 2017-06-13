#!/bin/bash

#
# run the environment:
# - (re)start docker-compose restart  
#

echo "starting containers"
SCRIPT_HOME=`dirname $0 | while read a; do cd $a && pwd && break; done`
cd $SCRIPT_HOME/../docker
docker-compose restart

