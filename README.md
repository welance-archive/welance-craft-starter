
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
      conf/             
        apache2/        - apache2 configuration files for CraftCMS
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
# cd into the docker/craft folder of the base project
cd docker/craft
# build a new image (this is going to be the 'latest' tag)
docker build -t welance/craft .
# list the images and pick up the id of the images just built
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
welance/craft       latest              18cd3db3e7df        About a minute ago   114 MB
<none>              <none>              be09b9e54c3d        About an hour ago    113 MB
...
# login to docker hub
docker login --username=yourhubusername
# tag your image  (other than 'latest')
docker tag 18cd3db3e7df welance/craft:2.6
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


## Workflow 

The following is the standard workflow to use with the projects using craft/docker for development

### Setup
##### Fork the starter project
create a fork of the latest release of the base repo : [https://github.com/welance/welance-craft-starter](https://github.com/welance/welance-craft-starter)

##### Run the setup script
first make sure that you have docker installed and running, you can download docker from [here](https://www.docker.com/community-edition).

run the `bin/install.sh` script. the script will ask for
  - customer number
  - project number
  - site name
  - local host/url 

and will generate the following files:

```
./bin/schema-import.sh
./bin/schema-export.sh
./docker/docker-compose.yml
./docker/docker-compose-stage.yml
```

after the setup is completed the command will crate and launch the containers. 

##### Commit
commit the chagnes to the repository, in particular the changes reated to:


### Development
The development phase of the project will involve 3 main resources:
- the `templates`folder
- the `condfig/schema.yaml`
- the `plugins` folder


### Staging
run `docker-compose -f ./docker/docker-compose-stage.yml -d up`
[TODO more infoz]

### Release
[TODO more infoz]

### Project removal
Once the project is finished to remove the resources associated with the project (containers and data) 
the `bin/uninstall.sh`script is provided.


## Troubleshooting

the project folder must be located in one of the **Docker File Sharing** paths. 
You can add a folder (for example the mamp one) by edit the prefernces of your docker installation



