FROM alpine:3.6

MAINTAINER Enrico Icardi "enrico@welance.com"


# Set craft cms version
ENV CRAFT_VERSION=2.6 
ENV CRAFT_BUILD=2992
ENV CRAFT_ZIP=Craft-$CRAFT_VERSION.$CRAFT_BUILD.zip

# install php/apache2/sha256sum
RUN apk add --no-cache \
apache2 \
apache2-ssl \
php7 \
php7-apache2 \
php7-pdo \
php7-pdo_mysql \
php7-mcrypt \
php7-gd \
php7-openssl \
php7-mbstring \
php7-json \
php7-curl \
php7-phar \
php7-mysqli \
php7-session \
php7-iconv \
php7-ctype \
php7-zip \
php7-xml \
unzip \
tar \
coreutils \
wget; \
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
mkdir -p /data; mkdir -p /run/apache2; \
cd /data; \
composer require nerds-and-company/schematic:3.8.*


# create the folder if not exists or apache will not start


# Download the latest Craft (https://craftcms.com/support/download-previous-versions)
ADD https://download.buildwithcraft.com/craft/$CRAFT_VERSION/$CRAFT_VERSION.$CRAFT_BUILD/$CRAFT_ZIP /tmp/$CRAFT_ZIP

# Extract craft to webroot & remove default template files
RUN unzip -qo /tmp/$CRAFT_ZIP -d /data

# Add the environment variable settings to public/index.php
#RUN mv $WEBROOT/index.php $CRAFTROOT/index.php.original
#RUN awk '!found && /\$craftPath/ {print;print "define(\"CRAFT_ENVIRONMENT\", env(\"CRAFT_ENVIRONMENT\"));";found=1;next} 1' $CRAFTROOT/index.php.original > $WEBROOT/index.php

# Cleanup
RUN rm /tmp/$CRAFT_ZIP 
#&& chown -Rf www-data:www-data $CRAFTROOT

ADD scripts /data/scripts
RUN chmod +x /data/scripts/*.sh
# this script will be used to orchestrate the startup of the containers
ADD scripts/poll-db.php /data/scripts/poll-db.php

EXPOSE 80
CMD ["/data/scripts/run-craft.sh"]

