#!/bin/bash

#
# install the environment:
# - run docker-compose up  
# - starts containers 
#

SCRIPT_HOME=`dirname $0 | while read a; do cd $a && pwd && break; done`
cd $SCRIPT_HOME/../docker
echo "project home is `pwd`"
docker-compose up -d

