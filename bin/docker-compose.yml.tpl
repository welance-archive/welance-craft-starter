version: '2.1'
services:
  craft:
    image: welance/craft3
    container_name: craft_%%PROJECTCOORDS%%
    build: 
      context: ./craft
    ports: # host_port:container_port
      - "80:80"
      - "443:443"
    volumes:
      # webserver and php mounts
      - /var/log
      - ./craft/conf/apache2/ssl:/etc/apache2/ssl
      - ./craft/conf/apache2/craft.conf:/etc/apache2/conf.d/craft.conf
      - ./craft/conf/php/php.ini:/etc/php7/php.ini
      - ./craft/logs/apache2:/var/log/apache2
      # adminer utility
      - ./craft/adminer:/data/adminer
      # craft 
      - ../config:/data/craft/config
      - ../templates:/data/craft/templates
      - ../migrations:/data/craft/migrations
      - ../plugins:/data/craft/plugins
      - ../web/uploads:/data/craft/web/uploads
      - ../composer.json:/data/craft/composer.json
    links:
      - database
    # env vars are replaced in /data/craft/config
    environment:
      # Set locale to UTF-8 
      LANG: C.UTF-8
      # Options are mysql or pgsql
      DB_DRIVER: mysql
      # only for pgsql, default public
      DB_SCHEMA: public
      # craft environment vars
      DB_SERVER: database
      DB_DATABASE: craft
      DB_PORT: 3306
      DB_USER: craft
      DB_PASSWORD: craft
      DB_TABLE_PREFIX: craft_
      SECURITY_KEY : %%SECURITYKEY%% 
      ENVIRONMENT : %%SITEENV%%
      # setup settings
      CRAFT_USERNAME : admin
      CRAFT_EMAIL : admin@welance.de
      CRAFT_PASSWORD : welance
      CRAFT_SITENAME : %%SITENAME%%
      CRAFT_SITEURL : %%SITEURL%%
      CRAFT_LOCALE : en_us
      # apache startup options
      HTTPD_OPTIONS : ""
  database:
      image: mysql:5.7
      command: mysqld --character-set-server=utf8 --collation-server=utf8_unicode_ci --init-connect='SET NAMES UTF8;'
      container_name: database_%%PROJECTCOORDS%%
      environment:
        MYSQL_ROOT_PASSWORD: craft
        MYSQL_DATABASE: craft
        MYSQL_USER: craft
        MYSQL_PASSWORD: craft
      volumes:
      - /var/lib/mysql

