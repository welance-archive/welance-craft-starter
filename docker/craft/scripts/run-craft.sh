#!/bin/sh


# this variables are the same used in Dockerfile
CRAFTROOT=/data/craft
WEBROOT=/data/public
SCRIPTS_DIR=/data/scripts

# this variables should stay in the docker-compose file
# export CRAFT_USERNAME="admin"
# export CRAFT_EMAIL="admin@welance.de"
# export CRAFT_PASSWORD="welance"
# export CRAFT_SITENAME="example.com"
# export CRAFT_SITEURL="//localhost:7080"
# export CRAFT_LOCALE="en_us"
# export CRAFT_ENVIRONMENT=".dev"

export CRAFT_BASE_PATH=$CRAFTROOT
export CRAFT_APP_PATH="$CRAFT_BASE_PATH/app/"
export CRAFT_CONFIG_PATH="$CRAFT_BASE_PATH/config/"
export CRAFT_PLUGINS_PATH="$CRAFT_BASE_PATH/plugins/"
export CRAFT_STORAGE_PATH="$CRAFT_BASE_PATH/storage/"
export CRAFT_TEMPLATES_PATH="$CRAFT_BASE_PATH/templates/"
export CRAFT_TRANSLATIONS_PATH="$CRAFT_BASE_PATH/translations/"
export CRAFT_PUBLIC_PATH=$WEBROOT
export ENV_LIVE=$CRAFT_CONFIG_PATH/.live


WELANCE_GRID_VERSION=1.0.0
WELANCE_TPL_VERSION=0.0.0
SCHEMATIC_VERSION=^3.8

# install schematic
# echo "installing schematic"
# cd $CRAFT_PLUGINS_PATH
# echo "{\"require\": {\"nerds-and-company/schematic\": \"$SCHEMATIC_VERSION\"}}" > composer.json
# composer install

## download sproutimport
#if [ ! -d "$CRAFT_PLUGINS_PATH/sproutimport" ]; then
# SPROUT_FILE=sprout_import.zip
# wget -nv https://sprout.barrelstrengthdesign.com/craft-plugins/import/download?v= -O $SPROUT_FILE
# unzip -q $SPROUT_FILE
# rm $SPROUT_FILE
#fi

## download welance-craft-grid-plugin
if [ ! -d "$CRAFT_PLUGINS_PATH/welancegrid" ]; then
 wget -nv https://github.com/welance/welance-craft-grid-plugin/archive/$WELANCE_GRID_VERSION.zip 
 unzip -q $WELANCE_GRID_VERSION.zip
 mv welance-craft-grid-plugin-$WELANCE_GRID_VERSION welancegrid
 rm $WELANCE_GRID_VERSION.zip
fi

# download the template
cd $CRAFT_TEMPLATES_PATH
if [ ! -f "$CRAFT_TEMPLATES_PATH/package.json" ]; then
 wget -nv https://github.com/welance/welance-craft-base-template/archive/$WELANCE_TPL_VERSION.zip 
 unzip -q $WELANCE_TPL_VERSION.zip
 mv welance-craft-base-template-$WELANCE_TPL_VERSION/* .
 rm -rf  $WELANCE_TPL_VERSION.zip welance-craft-base-template-$WELANCE_TPL_VERSION
 #ln -s assets $DATA_CRAFT_PUBLIC/
fi

# if is a live environment (not docker build run schematic)
if [ -f $ENV_LIVE ]; then
 echo "cheking database connection"
 # check if mysql is alive
 OUT=1
 while [ $OUT -eq 1 ]; do
  php -f $SCRIPTS_DIR/poll-db.php $CRAFT_CONFIG_PATH/db.php $CRAFT_ENVIRONMENT
  OUT=$?
  echo "connection unavailable waiting 3 seconds before retry"
  sleep 3
 done
 #import schematic
 cd /data
 ./vendor/bin/schematic import
 # fix  privleges
 #chown -R apache /etc/apache2 
 chown -R apache $CRAFT_STORAGE_PATH
 #chown -R apache /data/public
 # run apache in foreground
 echo "launch apache2 in foreground"
 set -e
 # Apache gets grumpy about PID files pre-existing
 rm -f /var/www/run/httpd.pid
 /usr/sbin/httpd -DFOREGROUND $HTTPD_OPTIONS
fi
