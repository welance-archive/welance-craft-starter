
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

## Workflow 

### Setup

### Development

### Staging

### Release

### Close




