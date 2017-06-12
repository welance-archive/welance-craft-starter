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

## move to the plugins folder
cd $CRAFT_PLUGINS_PATH
## download welance-craft-grid-plugin
if [ ! -d "$CRAFT_PLUGINS_PATH/welancegrid" ]; then
 wget -nv https://github.com/welance/welance-craft-grid-plugin/archive/$PLUGIN_WELANCE_GRID_VERSION.zip 
 unzip -q $PLUGIN_WELANCE_GRID_VERSION.zip
 mv welance-craft-grid-plugin-$PLUGIN_WELANCE_GRID_VERSION $CRAFT_PLUGINS_PATH/welancegrid
 rm $PLUGIN_WELANCE_GRID_VERSION.zip
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
