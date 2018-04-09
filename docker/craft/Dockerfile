FROM alpine:3.6

LABEL mainteiner="andrea@welance.com"


# Set craft cms version
ENV CRAFT_PROJECT_VERSION='^1.0'

# install php/apache2/sha256sum
RUN apk add --no-cache \
apache2 \
apache2-ssl \
php7 \
php7-apache2 \
php7-pdo \
php7-pdo_mysql \
php7-pdo_pgsql \
php7-pgsql \
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
php7-zlib \
php7-xml \
php7-simplexml \
php7-zlib \
php7-dom \
php7-fileinfo \
php7-intl \
php7-xdebug \
coreutils \
wget \
tar \
gzip \
&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
&& mkdir -p /data && mkdir -p /run/apache2 \
&& composer create-project craftcms/craft:${CRAFT_PROJECT_VERSION} /data/craft \
&& rm /data/craft/.env \
# remove xdebug since we'll decide in the php.ini file to enable it or not
&& rm /etc/php7/conf.d/*xdebug.ini  

ADD scripts /data/scripts
# fix permissions
RUN chmod +x /data/scripts/*.sh \
&& chown -R apache:apache /data/craft 

# everthing is in /data
WORKDIR /data
# expose port 80
EXPOSE 80
CMD ["/data/scripts/run-craft.sh"]

