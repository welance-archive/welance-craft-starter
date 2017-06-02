FROM alpine:3.6

MAINTAINER Enrico Icardi "enrico@welance.de"

# install php/apache2/sha256sum
RUN apk add --no-cache \
apache2 \
php7-apache2 \
php7-pdo \
php7-pdo_mysql \
php7-mcrypt \
php7-gd \
php7-openssl \
php7-mbstring \
php7-json \
php7-curl \
unzip \
coreutils 


# Set craft cms version
ENV CRAFT_VERSION=2.6 CRAFT_BUILD=2980
ENV CRAFT_ZIP=Craft-$CRAFT_VERSION.$CRAFT_BUILD.zip
ENV CRAFTROOT=/var/www/localhost/craft
ENV WEBROOT=/var/www/localhost/htdocs
# Remove default webroot files & set PHP session handler to Redis
RUN rm -rf $WEBROOT/*

# Download the latest Craft (https://craftcms.com/support/download-previous-versions)
ADD https://download.buildwithcraft.com/craft/$CRAFT_VERSION/$CRAFT_VERSION.$CRAFT_BUILD/$CRAFT_ZIP /tmp/$CRAFT_ZIP

# Extract craft to webroot & remove default template files
RUN unzip -qqo /tmp/$CRAFT_ZIP 'craft/*' -d $CRAFTROOT && \
    rm -rf $CRAFTROOT/templates/*

# Add the environment variable settings to public/index.php
#RUN mv $WEBROOT/index.php $CRAFTROOT/index.php.original
#RUN awk '!found && /\$craftPath/ {print;print "define(\"CRAFT_ENVIRONMENT\", env(\"CRAFT_ENVIRONMENT\"));";found=1;next} 1' $CRAFTROOT/index.php.original > $WEBROOT/index.php

# Cleanup
RUN rm /tmp/$CRAFT_ZIP 
#&& chown -Rf www-data:www-data $CRAFTROOT


EXPOSE 80
CMD ["httpd-foreground"]

