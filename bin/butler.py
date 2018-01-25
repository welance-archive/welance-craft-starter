#! /usr/bin/env python
# -*- coding: utf-8 -*-
""" butler allows to setup a welance craft3 cms project """

import sys
import inspect
from pathlib import Path
import os
import secrets
import subprocess
import json
import requests
import yaml



class Settings(object):
    pass

settings = Settings()
settings.script_name = "butler.py"
# name of the project configuration file
settings.project_conf_file = ".env.json"
settings.dockerhub_cms_image = "welance/craft"
settings.dockerhub_mysql_image = "library/mysql"
settings.dockerhub_pgsql_image = "library/posgtre"
# name of the docker-compose dev file
settings.docker_compose_local = "docker-compose.yml"
# name of the docker-compose staging file
settings.docker_compose_stage = "docker-compose-staging.yml"
# name of the database seed file
settings.database_seed = "database-seed.sql"
# base domain to create the app staging url
settings.staging_domain = "staging.welance.de"
# default values for configuration
settings.default_slack_channel = "general"
settings.default_local_url = "localhost"
settings.default_site_name = "Welance"
settings.default_site_url = "localhost"
settings.default_db_driver = "mysql"
settings.default_db_user = "craft"
settings.default_db_pass = "craft"
settings.default_db_name = "craft"
settings.default_db_schema = "public"

""" name of the out configuration file """


class Commander(object):
    """ main class for command exectution"""

    def __init__(self, cfg):
        self.cfg = cfg
        filename = inspect.getframeinfo(inspect.currentframe()).filename
        script_path = Path(filename).resolve()
        self.project_path = script_path.parent.parent
        self.config_path = os.path.join(script_path.parent,self.cfg.project_conf_file)
        self.project_conf = {}
        if os.path.exists(self.config_path):
            fp = open(self.config_path, 'r')
            self.project_conf = json.load(fp)
            fp.close()
        # path for staging and local yaml
        self.local_yml = os.path.join(self.project_path, "docker", self.cfg.docker_compose_local)
        self.stage_yml = os.path.join(
            self.project_path, "docker", self.cfg.docker_compose_stage)

    def prjc(self, sep="_"):
        """shortcut to get project coordinates like C_P"""
        return "%s%s%s" % (self.project_conf['customer_number'], sep, 
                               self.project_conf['project_number'])
    def pcd(self):
        """shortcut to get the docker project code that is c{customer number}p{projectnumber}"""
        return "c%sp%s" % (self.project_conf['customer_number'],
                           self.project_conf['project_number'])

    def p(self, prompt_key):
        """ retrieve the message of a prompt  """
        # dictionary with the messages to print in th prompt
        prompts = {
            "project_ovverride": "The project is already setup boss, do you want to overwrite the configuration? (yes/no)? [no]: ",
            "setup_abort": "orrait boss, setup canceled, bye!",
            "customer_number": "Please enter the customer number, boss: ",
            "project_number": "Now enter the project number: ",
            "slack_channel": "What is the slack channel for this project? [%s]: " % self.cfg.default_slack_channel,
            "site_name": "And the site name? [%s]: " % self.cfg.default_site_name,
            "local_url": "Url for development [%s]: " % self.cfg.default_local_url,
            "db_driver": "Which database will you use pgsql/mysql? [%s]: " % self.cfg.default_db_driver,
            "setup_confirm": "are this info correct? (yes/no)? [no]: ",
            "project_teardown": "This action will remove all containers including data, do you want to continue (yes/no)? [no]: ",
            "image_version": "Which version do you want to use? [default with *]: "
        }
        return prompts.get(prompt_key)

    def docker_compose(self, params, yaml_path="docker-compose.yml"):
        """ execte docker-compose commmand """
        cmd = "docker-compose -f %s %s " % (yaml_path, params)
        print(cmd)
        subprocess.run(cmd,shell=True,check=True)

    def docker_exec(self, container_target, command, additional_options=""):
        """ execte docker exec commmand """
        cmd = """docker exec -i "%s" sh -c '%s' %s""" % (container_target, command, additional_options)
        print(cmd)
        subprocess.run(cmd, shell=True, check=True)
    
    def docker_cp(self, container_source, container_path, local_path="."):
        """ copy a file from a container to the host """
        # docker cp <containerId>:/file/path/within/container /host/path/target
        cmd = """docker cp %s:%s %s""" % (container_source,container_path,local_path )
        print(cmd)
        subprocess.run(cmd, shell=True, check=True)
    
    def dockerhub_image_versions(self, name, max_results=0):
        """retrieve the list of versions and it's size in MB of an image from docker hub"""
        url = "https://registry.hub.docker.com/v2/repositories/%s/tags/" % (name)
        # url = 'http://localhost:9999/download.json'
        try:
            images = requests.get(url).json()
        except:
            print("sorry chief, I cannot contact dockerhub right now, try again later")
            exit(0)
        default_version = 0
        versions = []
        for v in images["results"]:
            if v['name'] == 'latest' and images['count'] > 1:
                continue
            versions.append((v['name'], v['full_size'] / 1048576))
        versions = versions[0:max_results] if max_results > 0 else versions
        return default_version, versions

    def prompt_yesno(self, prompt_key):
        """ prompt the user for a yes/no question, when yes return true, false otherwise"""
        val = input(self.p(prompt_key))
        if val.strip().lower() == 'yes':
            return True
        return False

    def prompt_int(self, prompt_key, min_val=0, max_val=None, def_val=None):
        """ prompt user for a int value, keep asking until a correct value is entered"""
        val = ""
        while True:
            try:
                val = input(self.p(prompt_key))
                # if there is a default value use it
                if not val and def_val is not None:
                    val = def_val
                    break
                # else check the boundaries
                if int(val) < min_val or (max_val is not None and int(val) > max_val):
                    raise ValueError("")
                break
            except ValueError:
                if max_val is not None:
                    print("sorry boss, choose something between %d and %d"%(min_val,max_val))
                else :
                    print("sorry boss, chose a number greater than %d" % (min_val))
        return val

    def prompt_string(self, prompt_key, default_val=""):
        """ read a string from a command line, apply default_val if the input is empty"""
        val = input(self.p(prompt_key)).strip()
        if not val:
            val = default_val
        return val

    def write_file(self, filepath, data):
        """ write a file to the filesystem """
        fp = open(filepath, 'w')
        fp.write(data)
        fp.close()

    def upc(self, key, default_value):
        """set a project_conf value if it is not alredy set"""
        if key not in self.project_conf:
            self.project_conf[key] = default_value
    
    
    #
    #  COMMANDS
    #
    
    def cmd_help(self):
        """ print help """
        print ('%s <command>' % SCRIPT_NAME)
        print ('where command are')

        # get all the commands
        for name, obj in inspect.getmembers(self, inspect.ismethod):
            if (name.startswith('cmd_')):
                print(" %14s - %s" % (name[4:].replace("_","-"), obj.__doc__))

    def cmd_setup(self):
        """ set up the application """
        gc = self.cfg
        pc = self.project_conf

        # if the config  already exists prompt what to do
        if pc and not self.prompt_yesno('project_ovverride'):
            print(self.p('setup_abort'))
            return
        ## ask for customer number
        pc['customer_number'] = self.prompt_int('customer_number')
        pc['project_number'] = self.prompt_int('project_number')
        pc['slack_channel'] = self.prompt_string('slack_channel', gc.default_slack_channel)
        pc['site_name'] = self.prompt_string('site_name', gc.default_site_name)
        pc['local_url'] = self.prompt_string('local_url', gc.default_local_url)
        pc['db_driver'] = self.prompt_string('db_driver', gc.default_db_driver)
        # retriewve image versions
        dv, vers = self.dockerhub_image_versions(gc.dockerhub_cms_image, 4)
        print("Here there are the available craft versions:")
        for i in range(len(vers)):
            num = "* [%2d]" % i if i == dv else "  [%2d]" % i
            print("%s %10s %dMb" % (num, vers[i][0], vers[i][1]))
        iv = int(self.prompt_int('image_version', 0, len(vers)-1, def_val=dv))
        # select the version name from the version chosen by the user
        pc["craft_image"] = "%s:%s" % (gc.dockerhub_cms_image, vers[iv][0])
        
        # build stage domain
        pc['stage_url'] = '%s.%s' % (self.prjc(sep="."), gc.staging_domain)

        ## print summary
        print("")
        print("Customer Number: %s" % pc['customer_number'])
        print("Project  Number: %s" % pc['project_number'])
        print("Slack channel  : %s" % pc['slack_channel'])
        print("Site Name      : %s" % pc['site_name'])
        print("Local Url      : %s" % pc['local_url'])
        print("Staging Url    : %s" % pc['stage_url'])
        print("Db Driver      : %s" % pc['db_driver'])
        print("Craft version  : %s" % pc['craft_image'])
        print("")
        ## ask for confirmation
        if (not self.prompt_yesno('setup_confirm')):
            print(self.p('setup_abort'))
            return
        # generate security key
        self.upc("security_key", secrets.token_hex(32))
        # set the other default values
        self.upc("docker_image_craft", "welance/craft3")
        self.upc("db_schema", "public")
        self.upc("db_server", "database")
        self.upc("db_database", "craft")
        self.upc("db_user", "craft")
        self.upc("db_password", "craft")
        self.upc("db_table_prefix", "craft_")
        self.upc("craft_username",  "admin")
        self.upc("craft_email",  "admin@welance.de")
        self.upc("craft_password",  "welance")
        self.upc("lang", "C.UTF-8")
        self.upc("environment", "dev")
        self.upc("craft_locale", "en_us")
        self.upc("httpd_options", "")

        # docker-compose.ymk
        docker_compose = {
            "version": "2.1",
            "services": {
                "craft": {
                    "image": pc["craft_image"],
                    "container_name": "craft_%s" % self.pcd(),
                    "ports": ["80:80", "443:443"],
                    "volumes": [
                        # webserver and php mounts
                        "/var/log",
                        "./craft/conf/apache2/ssl:/etc/apache2/ssl",
                        "./craft/conf/apache2/craft.conf:/etc/apache2/conf.d/craft.conf",
                        "./craft/conf/php/php.ini:/etc/php7/php.ini",
                        "./craft/logs/apache2:/var/log/apache2",
                        # adminer utility
                        "./craft/adminer:/data/adminer",
                        # craft
                        "../config:/data/craft/config",
                        "../templates:/data/craft/templates",
                        "../migrations:/data/craft/migrations",
                        "../plugins:/data/craft/plugins",
                        "../web/uploads:/data/craft/web/uploads",
                        "../composer.json:/data/craft/composer.json"
                    ],
                    "links": ["database"],
                    "environment": {
                        "LANG": pc["lang"],
                        "DB_DRIVER": pc['db_driver'],
                        "DB_SCHEMA": pc["db_schema"],
                        "DB_SERVER": pc["db_server"],
                        "DB_DATABASE": pc["db_database"],
                        "DB_USER": pc["db_user"],
                        "DB_PASSWORD": pc["db_password"],
                        "DB_TABLE_PREFIX": pc["db_table_prefix"],
                        "SECURITY_KEY": pc['security_key'],
                        "ENVIRONMENT": pc["environment"],
                        "CRAFT_USERNAME": pc["craft_username"],
                        "CRAFT_EMAIL": pc["craft_email"],
                        "CRAFT_PASSWORD": pc["craft_password"],
                        "CRAFT_SITENAME": pc['site_name'],
                        "CRAFT_SITEURL": pc['local_url'],
                        "CRAFT_LOCALE": pc["craft_locale"],
                        "HTTPD_OPTIONS": pc["httpd_options"]
                    }
                }
            }
        }
        if pc['db_driver'] == 'mysql':
            docker_compose["services"]["database"] = {
                "image":
                "mysql:5.7",
                "command":
                "mysqld --character-set-server=utf8  --collation-server=utf8_unicode_ci --init-connect='SET NAMES UTF8;'",
                "container_name":
                "database_%s" % self.pcd(),
                "environment": {
                    "MYSQL_ROOT_PASSWORD": self.project_conf["db_password"],
                    "MYSQL_DATABASE": self.project_conf["db_database"],
                    "MYSQL_USER": self.project_conf["db_user"],
                    "MYSQL_PASSWORD": self.project_conf["db_password"]
                },
                "volumes": ["/var/lib/mysql"]
            }
            # set the correct DB_PORT for craft env
            docker_compose["services"]["craft"]["environment"]["DB_PORT"] = "3306"
        elif pc['db_driver'] == 'pgsql':
            docker_compose["services"]["database"] = {
                "image": "postgres:10-alpine",
                "container_name": "database_%s" % self.pcd(),
                "environment": {
                    "POSTGRES_PASSWORD": pc["db_password"],
                    "POSTGRES_USER": pc["db_user"],
                    "POSTGRES_DB": pc["db_database"]
                },
                "volumes": ["/var/lib/postgresql/data"]
            }
            # set the correct DB_PORT for craft env
            docker_compose["services"]["craft"]["environment"]["DB_PORT"] = "5432"
        else:
            print("the value for Db Driver must be mysql or pgsql")
            print(self.p('setup_abort'))
            return

        # save docker-composer
        self.write_file(self.local_yml, yaml.dump(docker_compose, default_flow_style=False))
        # edit for docker-compose.staging.yaml
        docker_compose["services"]["craft"].pop("ports")
        docker_compose["services"]["craft"]["expose"] = [80, 443]
        docker_compose["services"]["craft"]["network_mode"] = "bridge"
        docker_compose["services"]["craft"]["environment"]["VIRTUAL_HOST"] = pc['stage_url']

        # save docker-composer
        self.write_file(self.stage_yml, yaml.dump(
            docker_compose, default_flow_style=False))

        # save project conf
        self.write_file(self.config_path, json.dumps(self.project_conf, indent=2))
        # all done

        print("pull doker images images")
        self.docker_compose("pull --ignore-pull-failures", self.local_yml)
        print("create containers")
        self.docker_compose("--project-name %s up --no-start " % self.pcd(), self.local_yml)
        print("setup completed")

    def cmd_restore(self):
        """restore a project that has been teardown, recreating the configurations """
        # if the config  already exists prompt what to do
        if self.project_conf:
            print("pull doker images images")
            self.docker_compose("pull --ignore-pull-failures", self.local_yml)
            print("create containers")
            self.docker_compose("--project-name %s up --no-start " % self.pcd(), self.local_yml)
            print("setup completed")
            return
        print("there is nothing to restore, perhaps you want to setup?")

    def cmd_local_start(self):
        """start the local docker environment"""
        self.docker_compose("--project-name %s up -d" % self.pcd(), self.local_yml )

    def cmd_local_stop(self):
        """stop the local docker environment"""
        self.docker_compose("--project-name %s stop" % self.pcd(),
                            self.local_yml)

    def cmd_local_teardown(self):
        """destroy the local docker environment"""
        if self.prompt_yesno('project_teardown'):
            self.docker_compose("--project-name %s down -v" % self.pcd(),
                                self.local_yml)

    def cmd_seed_export(self):
        """export the database-seed.sql"""
        seed_file = os.path.join(self.project_path, "config",
                                 self.cfg.database_seed)
        # run mysql dump
        container_target = "database_%s" % self.pcd()
        command = """exec mysqldump -uroot -p"craft" --add-drop-table craft"""
        if self.project_conf["db_driver"] == "pgsql":
            command = """exec pg_dump --clean --if-exists -U craft -d craft"""
        additional_options = "> %s" % seed_file
        self.docker_exec(container_target, command, additional_options)

    def cmd_seed_import(self):
        """import the database-seed.sql"""
        seed_file = os.path.join(self.project_path, "config",
                                 self.cfg.database_seed)
        # run mysql dump
        container_target = "database_%s" % self.pcd()
        command = """exec mysql -u%s -p"%s" %s""" % (
            self.cfg.default_db_user, self.cfg.default_db_pass, self.cfg.default_db_name)
        if self.project_conf["db_driver"] == "pgsql":
            command = """exec psql --quiet -U %s -d "%s" """ % (self.cfg.default_db_user, self.cfg.default_db_name)
        additional_options = "< %s" % seed_file
        self.docker_exec(container_target,command, additional_options)

    def cmd_package_release(self):
        """create a gzip containg the project release"""
        # dump the seed database 
        self.cmd_seed_export()
        container = "craft_%s" % self.pcd()
        release_path = "/data/release.tar.gz"
        # create archive of the /data/craft directory
        # maybe some directories could be escluded ?
        cmd = "tar -cv /data/craft | gzip > %s" % release_path
        self.docker_exec(container, cmd)
        # copy the archive locally 
        self.docker_cp(container, release_path, self.project_path)
        # remove the archive in the container
        cmd = "rm %s" % release_path
        self.docker_exec(container, cmd)


# main function
def main():
    """run the butler system"""

def cmd2method(cmd):
  return "cmd_%s" % cmd.replace("-","_")


if __name__ == '__main__':
    SCRIPT_NAME = sys.argv[0]
    c = Commander(settings)
    if len(sys.argv) == 1 or not hasattr(c, cmd2method(sys.argv[1])):
        c.cmd_help()
        exit(0)
    getattr(c, cmd2method(sys.argv[1]))()
