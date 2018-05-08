
# Welance CraftCMS + Docker

The project is the base to fork to create new projects using craft cms.
The repository contains the 
- docker configuration for craft container
- docker-compose configuration to run the craft+mysql enviroment
- base schema customization of the craft installation
- apache configuration 
- base template for craft frontend
- utility scripts to start/stop the enviroment 
- utility scripts to import/export craft schema changes


## Directory layout

The following is the directory layout
```
/
  bin/                  - contains scripts to start/stop the development environment
  docker/               - contains the configuration/scripts/resources for docker
    craft/              - definition of the container for CraftCMS 
      adminer/          - php mysql frontend
      conf/             
        apache2/        - apache2 configuration files for CraftCMS
        php/            - php configuration file (php.ini)
      logs/
        apache2/        - apache2 logs 
      scripts/          - scripts used to setup/update the container (CMD/ENTYPOINTS)
  config/               - CraftCMS config folder
  plugins/              - CraftCMS plugins folder
  templates/            - CraftCMS templates folder
  public/               - CraftCMS public folder 
```

## Docker HUB image

the craft cms image is available [here](https://hub.docker.com/r/welance/craft/)

### Publish an image

To publish an updated image of CraftCMS container to docker hub do the folowing:

```
make docker-publish TAG=$CRAFT_VERSION
```

where `$CRAFT_VERSION` is the craft version to publish, for example 

```
make docker-publish TAG=3.0.5 
```

will publish the image `welance/craft:3.0.5` to the docker hub registry

Alternatively, the long version is:

```
# cd into the docker/craft folder of the base project
cd docker/craft
# build a new image (this is going to be the 'latest' tag)
docker build -t welance/craft:CRAFT_VERSION .
# list the images and pick up the id of the images just built
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
welance/craft       CRAFT_VERSION           18cd3db3e7df        About a minute ago   114 MB
<none>              <none>              be09b9e54c3d        About an hour ago    113 MB
...
# login to docker hub
docker login --username=yourhubusername
# push the image
docker push welance/craft
```

### Docker (useful) commands

the following is a selection of docker commands that may be handy when working with docker, 
for full reference consult the [docker documentation](https://docs.docker.com/engine/reference/run/)

- list installed images: `docker images`
- list untagged images (DANGLING) `docker images --filter "dangling=true`
- remove all untagged images `docker rmi $(docker images -f "dangling=true" -q)`
- remove all images `docker rmi $(docker images -q)`
- list running containers `docker ps`
- list all containers `docker ps --all`
- stop all running containers `docker stop $(docker ps -q)`
- open a shell into the craft container `docker exec -it [CONTAINER_ID/CONTAINR_NAME] /bin/sh`


## Workflow 

The following is the standard workflow to use with the projects using craft/docker for development

### Setup


##### Fork the starter project
create a fork of the latest release of the base repo : [https://github.com/welance/welance-craft-starter](https://github.com/welance/welance-craft-starter)


##### Install python/libs and bash completion 

make sure to have python3 installed, use [virtualenv](https://virtualenv.pypa.io/en/stable/) if necessary. 

run 
  - `pip install -r bin/requirements.txt` to install the required libraries and 
  - `source bin/butler.bash-completion` to enable commands autocompletion



##### Run butler.py setup
first make sure that you have docker installed and running, you can download docker from [here](https://www.docker.com/community-edition).

run the `bin/butler.py setup` script. the script will ask for

  - customer number
  - project number
  - slack channel
  - site name
  - local host/url 
  - database driver (mysql or pgsql)


and will generate the following files:

```
./bin/.env.json
./docker/docker-compose.yml
./docker/docker-compose-staging.yml
```

after the setup is completed the docker environment can be started.

> **!!! ATTENTION !!!** 
> customer and project number are used to setup the containers environment, 
> they cannot be easily changed once the project is on-going.

##### Commit
commit the chagnes to the repository, in particular the changes reated to:

```
./bin/.env.json
./docker/docker-compose.yml
./docker/docker-compose-staging.yml
```

### Development

During the development here are the most used commands:

##### Start the docker dev environment
`bin/butler.py local-start` script starts the docker containers and refreshes the schema.yaml
> **!!! ATTENTION !!!** 
> at each restart the `config/schema.yaml` will be reloaded,
> if you have made any changes to the schema you will have to export
> it before stopping the docker environment!


Once the containers are started the following ports are available:
- 80   for http
- 443  https with a self signed certificate

The default credentials (user/pass) for mysql are `craft`/`craft`.

The development phase of the project will involve 3 main resources:
- the `templates`folder
- the `config/schema.yaml`
- the `plugins` folder

##### Stop the docker dev environment
`bin/butler.py local-stop` stops the docker conatiners. It doesn't delete the database or cms data.

##### Import/Export schema
To import/export the [craft schema](https://github.com/nerds-and-company/schematic) there is 

- `bin/butler.py schema-export`
- `bin/butler.py schema-import`

the schema is imported/exported from `config/schema.yml`

##### Import/Export database seed
To import/export the dump of the database that it is used to setup/seed the database

- `bin/butler.py seed-export`
- `bin/butler.py seed-import`

the seed sql file is imported/exported from `config/database-seed.sql`



### Staging

For staging environment are available the commands:
- `bin/butler.py staging-start`
- `bin/butler.py staging-stop`
- `bin/butler.py staging-teardown`

they are used by the [welance clerk](https://github.com/welance/docker-staging) system


### Release
To create an tar.gz archive of the craft installation use the command

- `bin/butler.py release-package` 

it will create a file `release.tar.gz` file in the root of the project containing
the craft installation with a **fresh database dump**

### Project removal
Once the project is finished to remove the resources associated with the project (containers and data) 
the `bin/butler.py local-teardown`script is provided.


## Applying Craftcms updates

Applying a craftcms update is a sensible activity that has to be performed with extreme care.

Craftcms autoupdate performs 2 actions:
- runs `composer update` for code 
- apply changes to the database and records changes in the table `info`:
  - `info.version` for craft version, ex 3.x
	- `info.schemaVersion` for the database schema version

it is therefore important that this operation is performed atomically in one machine
and the result propagated to the other installations. 

The steps to perform an upgrade during development are:
  - freeze content editing.
	- obtain a copy of the latest official database seed (ex. from staging)
	- perform the upgrade locally 
	- run the `seed-export` and commit the changes to the database
	- update the `docker/docker-compose.yml` and `docker-compose-staging.yml` with the new version 
	- commit the result




## Accessing the database
Since the database use in the containers is not accessible from outside docker a database web interface
is provided to dump/load/edit the database directly. The interface of the database is [Adminer](https://www.adminer.org/) and 
is available via http or https.

The urls are:
- [http://HOST/db](http://localhost/db) 
- [https://HOST/db](https://localhost/db). 

The parameters to log in are:
- System: MySQL or PostgreSQL depending on the driver selected
- Server: database
- Username: craft
- Password: craft
- Database: craft

## Apache configuration and .htaccess
The website apache configuration is stored in `./docker/craft/conf/apache2/conf.d/welance.conf`.
The welance.conf contains all the settings for the installation to work and should be taken as a reference
for production installation. By default .htaccess is _DISABLED_, [because](https://nystudio107.com/blog/stop-using-htaccess-files-no-really).
Changes to the apache configuration require to restart the environment (`bin/butler.py local-stop`, `bin/butler.py local-start`) to be enabled.

## Troubleshooting

**Docker**: the project folder must be located in one of the **Docker File Sharing** paths. 
You can add a folder (for example the mamp one) by edit the prefernces of your docker installation

**CraftCMS**: if you log in using HTTPS login with HTTP fails. This has someting to do with sessions
and CSRF protection. To solve the issue clear the browser application data and retry.

**Adminer**: if you log in using HTTPS login with HTTP fails. This has someting to do with sessions
and CSRF protection. To solve the issue clear the browser application data and retry.

## SSL

the certificate shipped with the project has been created using:

```
localhost:/# openssl req -x509 -nodes -days 1825 -newkey rsa:2048 -keyout welance.ssl.key -out welance.ssl.crt
Generating a 2048 bit RSA private key
....................+++
....................................................................+++
writing new private key to 'welance.ssl.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) []:DE
State or Province Name (full name) []:Berlin
Locality Name (eg, city) []:Berlin
Organization Name (eg, company) []:Welance
Organizational Unit Name (eg, section) []:
Common Name (eg, fully qualified host name) []:
Email Address []:info@welance.de
```

## Acknowledgements

The project (docker/scripts/procedures/etc.) has been realized by [Andrea Giacobino](mailto:andrea@welance.com) 
from a request of [Enrico Icardi](mailto:enrico@welance.de).