version: '2.1'
services:
  craft:
    image: welance/craft:3
    container_name: craft_%%PROJECTCOORDS%%
    build: 
      context: ./craft
    ports: # host_port:container_port
      - "80:80"
      - "443:443"
    volumes:
      - /var/log
      - ./craft/conf/apache2:/etc/apache2
      - ./craft/logs/apache2:/var/log/apache2
      - ./craft/adminer:/data/adminer
      - ../config:/data/craft/config
      - ../templates:/data/craft/templates
      - ../migrations:/data/craft/migrations
      - ../plugins:/data/craft/plugins
      - ../web:/data/craft/web
      - ../composer.json:/data/craft/composer.json
      
    links:
      - database
    # env vars are replaced in /data/craft/config
    environment:
      # Set locale to UTF-8 
      LANG: C.UTF-8
      # DB is linked
      DB_HOST: database
      # Options are mysql or pgsql
      DB_DRIVER: mysql
      DB_NAME: craft
      # only for pgsql, default public
      DB_SCHEMA: public
      # optional, default 3306 for mysql and 5432 for pgsql
      DB_PORT: 3306
      DB_USER: craft
      DB_PASS: craft
      CRAFT_USERNAME : admin
      CRAFT_EMAIL : admin@welance.de
      CRAFT_PASSWORD : welance
      CRAFT_SITENAME : %%SITENAME%%
      CRAFT_SITEURL : %%SITEURL%%
      CRAFT_LOCALE : en_us
      CRAFT_SECURITY_KEY : %%SECURITYKEY%% 
      CRAFT_ENVIRONMENT : %%SITEENV%%
      PLUGIN_WELANCE_GRID_VERSION : "1.0.0"
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

