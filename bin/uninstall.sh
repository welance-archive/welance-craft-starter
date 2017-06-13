#!/bin/bash

#
# uninstall the environment:
# - run docker-compose down
#

SCRIPT_HOME=`dirname $0 | while read a; do cd $a && pwd && break; done`
cd $SCRIPT_HOME/../docker

echo -n "This action will remove all containers including data, do you want to continue (YES/NO)? [NO] "
read answer
if echo "$answer" | grep -q "^YES" ;then
    echo "uninstalling project"
    docker-compose down
else
    echo "aborting"
fi

