#!/bin/sh

lockfile="/var/www/localhost/craft/config/install.lock"

# this variables are the same used in Dockerfile
CRAFTROOT=/var/www/localhost/craft
WEBROOT=/var/www/localhost/htdocs

export CRAFT_USERNAME="admin"
export CRAFT_EMAIL="admin@welance.de"
export CRAFT_PASSWORD="welance"
export CRAFT_SITENAME="example.com"
export CRAFT_SITEURL="//localhost:7080"
export CRAFT_LOCALE="en_us"

export CRAFT_BASE_PATH=$CRAFTROOT
export CRAFT_APP_PATH="$CRAFT_BASE_PATH/app/"
export CRAFT_CONFIG_PATH="$CRAFT_BASE_PATH/config/"
export CRAFT_PLUGINS_PATH="$CRAFT_BASE_PATH/plugins/"
export CRAFT_STORAGE_PATH="$CRAFT_BASE_PATH/storage/"
export CRAFT_TEMPLATES_PATH="$CRAFT_BASE_PATH/templates/"
export CRAFT_TRANSLATIONS_PATH="$CRAFT_BASE_PATH/translations/"
export CRAFT_PUBLIC_PATH=$WEBROOT

WELANCE_GRID_VERSION=1.0.0
WELANCE_TPL_VERSION=0.0.0

# install schematic
echo "installing schematic"
cd $CRAFT_PLUGINS_PATH
echo '{"require": {"nerds-and-company/schematic": "^3.8"}}' > composer.json
composer install

## download sproutimport
if [ ! -d "$CRAFT_PLUGINS_PATH/sproutimport" ]; then
 wget https://sprout.barrelstrengthdesign.com/craft-plugins/import/download?v= -O sprout_import.zip
 unzip sprout_import.zip 
fi

## download welance-craft-grid-plugin
if [ ! -d "$CRAFT_PLUGINS_PATH/welancegrid" ]; then
 wget https://github.com/welance/welance-craft-grid-plugin/archive/$WELANCE_GRID_VERSION.zip 
 unzip $WELANCE_GRID_VERSION.zip
 mv welance-craft-grid-plugin-$WELANCE_GRID_VERSION welancegrid
fi

# download the template
cd $CRAFT_TEMPLATES_PATH
if [ ! -f "$CRAFT_TEMPLATES_PATH/package.json" ]; then
 wget https://github.com/welance/welance-craft-base-template/archive/$WELANCE_TPL_VERSION.zip 
 unzip $WELANCE_TPL_VERSION.zip
 mv welance-craft-base-template-$WELANCE_TPL_VERSION/* .
 rm -rf  $WELANCE_TPL_VERSION.zip welance-craft-base-template-$WELANCE_TPL_VERSION
 ln -s assets $DATA_CRAFT_PUBLIC/
fi

#/data/craft/craft/plugins/vendor/bin/schematic import --file=/data/craft/craft/config/schema.yml --force
/data/craft/craft/plugins/vendor/bin/schematic import --file=/data/craft/craft/config/schema.yml
