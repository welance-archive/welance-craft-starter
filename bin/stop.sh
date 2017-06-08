#!/bin/bash

#
# stop the environment:
# - stop containers: run docker-compose stop  
#

SCRIPT_HOME=`dirname $0 | while read a; do cd $a && pwd && break; done`
cd $SCRIPT_HOME/../docker
echo "project home is `pwd`"
docker-compose stop