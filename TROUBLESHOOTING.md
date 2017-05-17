# Installation of directus + node

this is what I've tried just to make directus work under /admin and I did succeeded but it is cumbersome and it will not work for the final required setup.

the steps assumes that:

- os is ubuntu 
- all the software (mysql,nginx,wget,unzip,etc..) are installed
- root access

# Scope

the required setup of the project is 

```
http://localhost/      -> reverse proxy to a node instance for (ssr)
http://localhost/admin -> serve directus interface 
http://localhost/api   -> serve directus api
```

## Steps

1. create destination folder:

```
# mkdir /data
# cd /data
```

1. download directus 

```
# wget https://github.com/directus/directus/archive/6.3.9.zip
# unzip 6.3.9.zip
# mv 6.3.9 directus
```

2. create database 

```
# mysql -u root -p 
> create database directus;
> grant all privileges on directus.* to 'directus' identified by 'directus';
> flush privileges;
> exit;
```

3. run directus install:config 

```
composer --working-dir="directus" install

export DIRECTUS_DB_HOST="localhost"
export DIRECTUS_DB_SCHEMA="directus"
export DIRECTUS_DB_USER="directus"
export DIRECTUS_DB_PASSWORD="directus"
export DIRECTUS_ADMIN_EMAIL="admin@admin.com"
export DIRECTUS_ADMIN_PASSWORD="admin123" # I know this is a big no no, but it is just to test an installation
export DIRECTUS_SITE_NAME="myapp"
export DIRECTUS_PATH="admin/" 

directus/bin/directus install:config -h "$DIRECTUS_DB_HOST" -n "$DIRECTUS_DB_SCHEMA" -u "$DIRECTUS_DB_USER" -p "$DIRECTUS_DB_PASSWORD" -d "$DIRECTUS_PATH"
```

here is one issue, if ```DIRECTUS_PATH``` is "admin" then I get the following error:

```
root@dev-local:/data# directus/bin/directus install:config -h "$DIRECTUS_DB_HOST" -n "$DIRECTUS_DB_SCHEMA" -u "$DIRECTUS_DB_USER" -p "$DIRECTUS_DB_PASSWORD" -d "$DIRECTUS_PATH"
PHP Warning:  file_put_contents(/data/directus/adminapi/config.php): failed to open stream: No such file or directory in /data/directus/api/core/Directus/Util/Installation/InstallerUtils.php on line 58
PHP Warning:  file_put_contents(/data/directus/adminapi/configuration.php): failed to open stream: No such file or directory in /data/directus/api/core/Directus/Util/Installation/InstallerUtils.php on line 82
root@dev-local:/data# 

```
if ```DIRECTUS_PATH``` is "admin/" then I get the following error:

```
root@dev-local:/data# directus/bin/directus install:config -h "$DIRECTUS_DB_HOST" -n "$DIRECTUS_DB_SCHEMA" -u "$DIRECTUS_DB_USER" -p "$DIRECTUS_DB_PASSWORD" -d "$DIRECTUS_PATH"
PHP Warning:  file_put_contents(/data/directus/admin/api/config.php): failed to open stream: No such file or directory in /data/directus/api/core/Directus/Util/Installation/InstallerUtils.php on line 58
PHP Warning:  file_put_contents(/data/directus/admin/api/configuration.php): failed to open stream: No such file or directory in /data/directus/api/core/Directus/Util/Installation/InstallerUtils.php on line 82
root@dev-local:/data# 
```

therefore I have to go without the ```-d``` option:

```
directus/bin/directus install:config -h "$DIRECTUS_DB_HOST" -n "$DIRECTUS_DB_SCHEMA" -u "$DIRECTUS_DB_USER" -p "$DIRECTUS_DB_PASSWORD"
```


4. run directus install:install / install:database

```
directus/bin/directus install:database
directus/bin/directus install:install -e "$DIRECTUS_ADMIN_EMAIL" -p "$DIRECTUS_ADMIN_PASSWORD" -t "$DIRECTUS_SITE_NAME"
```

5. fix permissions

```
chown -R www-data:www-data directus
```

6. configure nginx 

using the configuration found [here](https://github.com/directus/directus-vagrant/blob/master/config/nginx/default)

with some changes:

- changed: listen 80 default_server; to listen 80;
- removed: listen [::]:80 default_server ipv6only=on;
- changed: root /var/www/html; to root /data/directus;
- changed: server_name localhost; to server_name _;
- changed: fastcgi_pass unix:/var/run/php5-fpm.sock; to fastcgi_pass unix:/run/php/php7.0-fpm.sock;

```
server {
  listen 80 default_server;

  root /data/directus;
  index index.php index.html index.htm;

  # Make site accessible from http://localhost/
  server_name _;
  sendfile off;

  location /api {
    if (!-e $request_filename) {
      rewrite ^/1/extensions/([^/]+) /api/api.php?run_extension=$1 last;
    }
    rewrite ^ /api/api.php?run_api_router=1 last;
  }

  location / {
    try_files $uri $uri/ /index.php$args;
  }

  # Force this file extension to be output as text
  location ~ ^/(media|storage)/.*\.(php|phps|php5|htm|shtml|xhtml|cgi.+)?$ {
    add_header Content-Type text/plain;
  }

  # No direct access to extension api file
  location ~* [^/]+/customs/extensions/api\.php$ {
    return 403;
  }

  # No direct access to customs api endpoints files
  location ~* /customs/endpoints/ {
    deny all;
  }

  error_page 404 /404.html;

  # redirect server error pages to the static page /50x.html
  #
  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }

  # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
  #
  location ~ \.php$ {
    try_files $uri =404;
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    fastcgi_pass unix:/var/run/php-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_param PHP_VALUE "always_populate_raw_post_data = -1"
    include fastcgi_params;
  }

  # deny access to .htaccess files, if Apache's document root
  # concurs with nginx's one
  #
  location ~ /\.ht {
    deny all;
  }
}
```
7. results 

directus is running correctly and is available at http://localhost

## Post installation changes

the target layout is the following:
- http://localhost/admin - directus 

### option 1)
changing api/config.php:

```
// Url path to Directus
// define('DIRECTUS_PATH', '/');
// define('DIRECTUS_PATH', '/admin');
```

going to the url http://localhost:7080/admin the pages redirects to:

http://localhost:7080/adminlogin.php  with a file not found error.

### option 2)

changing api/config.php:

```
// Url path to Directus
// define('DIRECTUS_PATH', '/');
// define('DIRECTUS_PATH', '/admin/');
```

going to the url http://localhost:7080/admin the pages redirects to:

http://localhost:7080/admin/login.php  with a file not found error.

the debug log of nginx explains why:

```
2017/04/20 11:38:04 [debug] 27402#27402: *153 fastcgi param: "SCRIPT_FILENAME: /data/directus/admin/login.php"
```

### option 3)

weird symlinking:

change api/config.php:

```
// Url path to Directus
// define('DIRECTUS_PATH', '/');
// define('DIRECTUS_PATH', '/admin/');
```

create a symlink to the project itself:

```
ln -s /data/directus /data/directus/admin
```

going to the url http://localhost:7080/admin the pages redirects to:

http://localhost:7080/admin/login.php  successfully.

but.

the login doesn't work 


### option 4)

weird symlinking + nginx chages

change api/config.php:

```
// Url path to Directus
// define('DIRECTUS_PATH', '/');
// define('DIRECTUS_PATH', '/admin/');
```

create a symlink to the project itself:

```
ln -s /data/directus /data/directus/admin
```

change the nginx configuration:

```
location /api {
    if (!-e $request_filename) {
      rewrite ^/1/extensions/([^/]+) /api/api.php?run_extension=$1 last;
    }
    rewrite ^ /api/api.php?run_api_router=1 last;
  }
```

to

```
  location /admin/api {
    if (!-e $request_filename) {
      rewrite ^/1/extensions/([^/]+) /admin/api/api.php?run_extension=$1 last;
    }
    rewrite ^ /admin/api/api.php?run_api_router=1 last;
  }

```


going to the url http://localhost:7080/admin the pages redirects to:

http://localhost:7080/admin/login.php  successfully.

and everything works.

## Conclusions

although the option 4. works it isn't really something I'd like to do :)