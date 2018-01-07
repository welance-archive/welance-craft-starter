version: '2'
services:
  craft:
    image: welance/craft:3
    container_name: craft_%%PROJECTCOORDS%%
    expose: 
      - 80
      - 443
    volumes:
      - /var/log
      - ./craft/conf/apache2:/etc/apache2
      - ./craft/logs/apache2:/var/log/apache2
      - ./craft/adminer:/data/adminer
      - ../config:/data/craft/config
      - ../templates:/data/craft/templates
      - ../plugins:/data/craft/plugins
      - ../migrations:/data/craft/migrations
      - ../public:/data/craft/web
    links:
      - database
    # set the network_mode to make the proxying in staging env working
    network_mode: bridge
    # env vars are replaced in /data/craft/config
    environment:
      # Set locale to UTF-8 
      LANG: C.UTF-8
      # DB is linked
      DB_HOST: database
      DB_NAME: craft
      DB_PORT: 3306
      DB_USER: craft
      DB_PASS: craft
      CRAFT_USERNAME: admin
      CRAFT_EMAIL: admin@welance.de
      CRAFT_PASSWORD: welance
      CRAFT_SITENAME: %%SITENAME%%
      CRAFT_SITEURL: %%SITEURL%%
      CRAFT_LOCALE: en_us
      CRAFT_ENVIRONMENT: %%SITEENV%%
      CRAFT_SECURITY_KEY : %%SECURITYKEY%% 
      PLUGIN_WELANCE_GRID_VERSION: "1.0.0"
      HTTPD_OPTIONS: ""
      VIRTUAL_HOST: %%SITEHOST%%
  database:
      image: mysql:5.7
      command: mysqld --character-set-server=utf8 --collation-server=utf8_unicode_ci --init-connect='SET NAMES UTF8;'
      container_name: database_%%PROJECTCOORDS%%
      # set the network_mode to make the proxying in staging env working
      network_mode: bridge
      environment:
        MYSQL_ROOT_PASSWORD: craft
        MYSQL_DATABASE: craft
        MYSQL_USER: craft
        MYSQL_PASSWORD: craft
      volumes:
      - /var/lib/mysql

