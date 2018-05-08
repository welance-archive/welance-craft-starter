#!/usr/bin/env python3
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
import re
import argparse
import webbrowser

config = {
    # configuration version
    'version': '3.0.0',
    # name of the project configuration file
    'project_conf_file': ".welance_prj.json",
    'dockerhub_cms_image': "welance/craft",
    'dockerhub_mysql_image': "library/mysql",
    'dockerhub_pgsql_image': "library/posgtre",
    # name of the docker-compose dev file
    'docker_compose_local': "docker-compose.yml",
    # name of the docker-compose staging file
    'docker_compose_stage': "docker-compose.staging.yml",
    # name of the database seed file
    'database_seed': "database-seed.sql",
    # base domain to create the app staging url
    'staging_domain': "staging.welance.de",
    # default values for configuration
    'default_slack_channel': "general",
    'default_local_url': "localhost",
    'default_site_name': "Welance",
    'default_site_url': "localhost",
    'default_db_driver': "mysql",
    'default_db_server': "database",
    'default_db_user': "craft",
    'default_db_pass': "craft",
    'default_db_name': "craft",
    'default_db_schema': "public",
    'default_db_table_prefix': "craft_",
    # craft defaults
    'default_craft_username': "admin",
    'default_craft_email': "admin@welance.de",
    'default_craft_passord': "welance",
    'default_craft_allow_updates': "false",
    # version management (semver)
    'semver_major': 0,
    'semver_minor': 0,
    'semver_patch': 0,
    # required plugins
    'composer_require': [
        'nerds-and-company/schematic',
        'craftcms/redactor',
        'craftcms/aws-s3'
    ]
}


""" name of the out configuration file """


#   _______  _______      ___   _______  ____    ____  _______   _________
#  |_   __ \|_   __ \   .'   `.|_   __ \|_   \  /   _||_   __ \ |  _   _  |
#    | |__) | | |__) | /  .-.  \ | |__) | |   \/   |    | |__) ||_/ | | \_|
#    |  ___/  |  __ /  | |   | | |  ___/  | |\  /| |    |  ___/     | |
#   _| |_    _| |  \ \_\  `-'  /_| |_    _| |_\/_| |_  _| |_       _| |_
#  |_____|  |____| |___|`.___.'|_____|  |_____||_____||_____|     |_____|
#

class Prompter(object):

    def p(self, prompt_key):
        """ retrieve the message of a prompt  """
        # dictionary with the messages to print in th prompt
        prompts = {
            "project_ovverride": "The project is already setup boss, do you want to overwrite the configuration? (yes/no)? [no]: ",
            "setup_abort": "orrait boss, setup canceled, bye!",
            "customer_number": "Please enter the customer number, boss: ",
            "project_number": "Now enter the project number: ",
            "slack_channel": "What is the slack channel for this project? [%s]: " % config['default_slack_channel'],
            "site_name": "And the site name? [%s]: " % config['default_site_name'],
            "local_url": "Url for development [%s]: " % config['default_local_url'],
            "db_driver": "Which database will you use pgsql/mysql? [%s]: " % config['default_db_driver'],
            "setup_confirm": "are this info correct? (yes/no)? [no]: ",
            "project_teardown": "This action will remove all containers including data, do you want to continue (yes/no)? [no]: ",
            "image_version": "Which version do you want to use? [default with *]: ",
            "semver": "options are\n  [0] major\n  [1] minor\n* [2] patch\nwhich one do you want? [patch]: "
        }
        return prompts.get(prompt_key)

    def say(self, prompt_key):
        """say something"""
        print(self.p(prompt_key))

    def ask_yesno(self, prompt_key):
        """ prompt the user for a yes/no question, when yes return true, false otherwise"""
        val = input(self.p(prompt_key))
        if val.strip().lower() == 'yes':
            return True
        return False

    def ask_int(self, prompt_key, min_val=0, max_val=None, def_val=None):
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
                    print("sorry boss, choose something between %d and %d" %
                          (min_val, max_val))
                else:
                    print("sorry boss, chose a number greater than %d" %
                          (min_val))
        return val

    def ask_str(self, prompt_key, default_val=""):
        """ read a string from a command line, apply default_val if the input is empty"""
        val = input(self.p(prompt_key)).strip()
        if not val:
            val = default_val
        return val


#   ______      ___      ______  ___  ____   ________  _______
#  |_   _ `.  .'   `.  .' ___  ||_  ||_  _| |_   __  ||_   __ \
#    | | `. \/  .-.  \/ .'   \_|  | |_/ /     | |_ \_|  | |__) |
#    | |  | || |   | || |         |  __'.     |  _| _   |  __ /
#   _| |_.' /\  `-'  /\ `.___.'\ _| |  \ \_  _| |__/ | _| |  \ \_
#  |______.'  `.___.'  `.____ .'|____||____||________||____| |___|
#

class DockerCli(object):
    def __init__(self, project_name, verbose=False):
        self.verbose = verbose
        self.project_name = project_name

    def compose(self, params, yaml_path="docker-compose.yml"):
        """ execte docker-compose commmand """
        cmd = f"docker-compose -f {yaml_path} {params}"
        print(cmd)
        try:
            subprocess.run(cmd, shell=True, check=True)
        except Exception:
            pass

    def compose_stop(self, yaml_path):
        self.compose(f"--project-name {self.project_name} stop ", yaml_path)

    def compose_start(self, yaml_path):
        self.compose(f"--project-name {self.project_name} up -d ", yaml_path)

    def compose_down(self, yaml_path):
        self.compose(f"--project-name {self.project_name} down -v", yaml_path)

    def compose_setup(self, yaml_path):
        self.compose(f"--project-name {self.project_name} up --no-start ", yaml_path)

    def compose_pull(self, yaml_path):
        self.compose("pull --ignore-pull-failures", yaml_path)

    def exec(self, container_target, command, additional_options=""):
        """ execte docker exec commmand and return the stdout or None when error"""
        cmd = """docker exec -i "%s" sh -c '%s' %s""" % (
            container_target, command, additional_options)
        if self.verbose:
            print(cmd)
        try:
            cp = subprocess.run(cmd,
                                shell=True,
                                check=True,
                                stdout=subprocess.PIPE)
            return cp.stdout.decode("utf-8").strip()
        except Exception as e:
            print(f"Docker exec failed command {e}")
            return None

    def cp(self, container_source, container_path, local_path="."):
        """ copy a file from a container to the host """
        # docker cp <containerId>:/file/path/within/container /host/path/target
        cmd = """docker cp %s:%s %s""" % (
            container_source, container_path, local_path)
        print(cmd)
        try:
            subprocess.run(cmd, shell=True, check=True)
        except Exception:
            pass

    @classmethod
    def list_image_versions(cls, name, max_results=0):
        """retrieve the list of versions and it's size in MB of an image from docker hub"""
        url = f"https://registry.hub.docker.com/v2/repositories/{name}/tags/"
        # url = 'http://localhost:9999/download.json'
        try:
            images = requests.get(url).json()
        except Exception:
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


#     ______  ____    ____  ______     ______
#   .' ___  ||_   \  /   _||_   _ `. .' ____ \
#  / .'   \_|  |   \/   |    | | `. \| (___ \_|
#  | |         | |\  /| |    | |  | | _.____`.
#  \ `.___.'\ _| |_\/_| |_  _| |_.' /| \____) |
#   `.____ .'|_____||_____||______.'  \______.'
#


class Commander(object):
    """ main class for command exectution"""

    def __init__(self, verbose=False):
        filename = inspect.getframeinfo(inspect.currentframe()).filename
        script_path = Path(filename).resolve()
        self.verbose = verbose
        # absolute path to the project root
        self.project_path = script_path.parent.parent
        # absolute path to the configuration file
        self.config_path = os.path.join(script_path.parent, config['project_conf_file'])
        # tells if the project has a configuration file
        self.project_is_configured = False
        self.project_conf = {}
        if os.path.exists(self.config_path):
            fp = open(self.config_path, 'r')
            self.project_conf = json.load(fp)
            fp.close()
            self.project_is_configured = True
            self.__register_env()
        # path for staging and local yaml
        self.local_yml = os.path.join(self.project_path, "build", config['docker_compose_local'])
        self.stage_yml = os.path.join(self.project_path, "build", config['docker_compose_stage'])
        # init command line cli
        self.prompt = Prompter()

    def __register_env(self):
        """will register the project coordinates and instantiate the clients"""
        # project code
        c, p = self.project_conf['customer_number'], self.project_conf['project_number']
        self.p_code = f"p{c}-{p}"
        self.db_container = f"database_{self.p_code}"
        self.cms_container = f"craft_{self.p_code}"
        # communicate with th propmt
        self.docker = DockerCli(self.p_code)

    def semver(self):
        """ create a string representation of the versino of the project """
        ma = self.project_conf.get("semver_major", config['semver_major'])
        mi = self.project_conf.get("semver_minor", config['semver_minor'])
        pa = self.project_conf.get("semver_patch", config['semver_patch'])
        self.project_conf["semver_major"] = ma
        self.project_conf["semver_minor"] = mi
        self.project_conf["semver_patch"] = pa
        return f"{ma}.{mi}.{pa}"

    def require_configured(self, with_containers=False):
        """ check if the project is configured or die otherwise """
        if not self.project_is_configured:
            print("the project is not yet configured, run the setup command first")
            exit(0)

    def upc(self, key, default_value):
        """set a project_conf value if it is not alredy set"""
        if key not in self.project_conf:
            self.project_conf[key] = default_value

    def write_file(self, filepath, data):
        """ write a file to the filesystem """
        fp = open(filepath, 'w')
        fp.write(data)
        fp.close()

    #
    #  COMMANDS
    #

    def cmd_setup(self, ns=None):
        """set up the application """
        # shorcut since "self.project_conf" is too long to write
        pc = self.project_conf
        # if the config  already exists prompt what to do
        if pc and not self.prompt.ask_yesno('project_ovverride'):
            print(self.prompt.say('setup_abort'))
            return
        # ask for customer number
        pc['customer_number'] = self.prompt.ask_int('customer_number')
        pc['project_number'] = self.prompt.ask_int('project_number')
        pc['slack_channel'] = self.prompt.ask_str('slack_channel', config['default_slack_channel'])
        pc['site_name'] = self.prompt.ask_str('site_name', config['default_site_name'])
        pc['local_url'] = self.prompt.ask_str('local_url', config['default_local_url'])
        pc['db_driver'] = self.prompt.ask_str('db_driver', config['default_db_driver'])
        # retriewve image versions
        dv, vers = DockerCli.list_image_versions(config['dockerhub_cms_image'], 4)
        print("Here there are the available craft versions:")
        for i in range(len(vers)):
            num = "* [%2d]" % i if i == dv else "  [%2d]" % i
            print("%s %10s %dMb" % (num, vers[i][0], vers[i][1]))
        iv = int(self.prompt.ask_int('image_version', 0, len(vers) - 1, def_val=dv))
        # select the version name from the version chosen by the user
        pc["craft_image"] = f"{config['dockerhub_cms_image']}:{vers[iv][0]}"
        # build stage domain
        c, p = pc['customer_number'], pc['project_number']
        pc['stage_url'] = f"p{c}-{p}.{config['staging_domain']}"
        #  print summary
        print("")
        print(f"Customer Number: {pc['customer_number']}")
        print(f"Project  Number: {pc['project_number']}")
        print(f"Slack channel  : {pc['slack_channel']}")
        print(f"Site Name      : {pc['site_name']}")
        print(f"Local Url      : {pc['local_url']}")
        print(f"Staging Host   : {pc['stage_url']}")
        print(f"Db Driver      : {pc['db_driver']}")
        print(f"Craft version  : {pc['craft_image']}")
        print("")
        # ask for confirmation
        if (not self.prompt.ask_yesno('setup_confirm')):
            print(self.prompt.say('setup_abort'))
            return
        # register env and instantiate docker cli
        self.__register_env()
        # generate security key
        self.upc("security_key", secrets.token_hex(32))
        # set the other default values
        self.upc("craft_image", config['dockerhub_cms_image'])
        self.upc("db_schema", config['default_db_schema'])
        self.upc("db_server", config['default_db_server'])
        self.upc("db_database", config['default_db_name'])
        self.upc("db_user", config['default_db_user'])
        self.upc("db_password", config['default_db_pass'])
        self.upc("db_table_prefix", config['default_db_table_prefix'])
        self.upc("craft_username", config['default_craft_username'])
        self.upc("craft_email", config['default_craft_email'])
        self.upc("craft_password",  config['default_craft_passord'])
        self.upc("semver_major", config['semver_major'])
        self.upc("semver_minor", config['semver_minor'])
        self.upc("semver_patch", config['semver_patch'])
        self.upc("craft_allow_updates", config['default_craft_allow_updates'])

        self.upc("lang", "C.UTF-8")
        self.upc("environment", "dev")
        self.upc("craft_locale", "en_us")
        self.upc("httpd_options", "")

        # docker-compose.yml
        docker_compose = {
            "version": "3.1",
            "services": {
                "craft": {
                    "image": pc["craft_image"],
                    "container_name": f"craft_{self.p_code}",
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
                        "../web/uploads:/data/craft/web/uploads",
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
                        "CRAFT_ALLOW_UPDATES": pc["craft_allow_updates"],
                        "CRAFT_DEVMODE": 1,  # enable development mode
                        "CRAFT_ENABLE_CACHE": 0,  # disable cache
                        "HTTPD_OPTIONS": pc["httpd_options"],

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
                "container_name": f"database_{self.p_code}",
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
                "container_name": f"database_{self.p_code}",
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
            print(self.prompt.say('setup_abort'))
            return

        # save docker-composer
        self.write_file(self.local_yml, yaml.dump(docker_compose, default_flow_style=False))
        # edit for docker-compose.staging.yaml
        docker_compose["services"]["craft"].pop("ports")
        docker_compose["services"]["craft"]["expose"] = [80, 443]
        docker_compose["services"]["craft"]["network_mode"] = "bridge"
        docker_compose["services"]["craft"]["environment"]["VIRTUAL_HOST"] = pc['stage_url']
        # disable develpment mode
        docker_compose["services"]["craft"]["environment"]["CRAFT_DEVMODE"] = 0
        docker_compose["services"]["craft"]["environment"]["CRAFT_ENABLE_CACHE"] = 1

        # save docker-composer
        self.write_file(self.stage_yml, yaml.dump(docker_compose, default_flow_style=False))

        # save project conf
        self.write_file(self.config_path, json.dumps(self.project_conf, indent=2))
        # all done

        print("pull doker images images")
        self.docker.compose_pull(self.local_yml)
        print("create containers")
        self.docker.compose_setup(self.local_yml)
        print("setup completed")

    def cmd_restore(self, ns=None):
        """restore a project that has been teardown, recreating the configurations """
        self.require_configured()
        # if the config  already exists prompt what to do
        if self.project_conf:
            print("pull doker images images")
            self.docker.compose_pull(self.local_yml)
            print("create containers")
            self.docker.compose_setup(self.local_yml)
            print("setup completed")
            return
        print("there is nothing to restore, perhaps you want to setup?")

    def cmd_local_start(self, ns=None):
        """start the local docker environment"""
        self.require_configured()
        self.docker.compose_start(self.local_yml)
        # run the plugin installation in case
        # they are not there yet or anymore
        for p in config['composer_require']:
            self.plugin_install(p)

    def cmd_local_stop(self, ns=None):
        """stop the local docker environment"""
        self.require_configured()
        self.docker.compose_stop(self.local_yml)

    def cmd_local_teardown(self, ns=None):
        """destroy the local docker environment"""
        self.require_configured()
        if self.prompt.ask_yesno('project_teardown'):
            self.docker.compose_down(self.local_yml)

    def cmd_seed_export(self, ns=None):
        """export the database-seed.sql"""
        self.require_configured(with_containers=True)
        seed_file = os.path.join(self.project_path, "config", config['database_seed'])
        # run mysql dump
        command = """exec mysqldump -uroot -p"craft" --add-drop-table craft"""
        if self.project_conf["db_driver"] == "pgsql":
            command = """exec pg_dump --clean --if-exists -U craft -d craft"""
        additional_options = "> %s" % seed_file
        self.docker.exec(self.db_container, command, additional_options)

    def cmd_seed_import(self, ns=None):
        """import the database-seed.sql"""
        self.require_configured(with_containers=True)
        seed_file = os.path.join(self.project_path, "config", config['database_seed'])
        # run mysql dump
        u, p, d = config['default_db_user'], config['default_db_pass'], config['default_db_name']
        command = f'exec mysql -u {u} -p"{p}" {d}'
        if self.project_conf["db_driver"] == "pgsql":
            command = f'exec psql --quiet -U {u} -d "{d}"'
        additional_options = "< %s" % seed_file
        self.docker.exec(self.db_container, command, additional_options)

    def cmd_info(self, ns=None):
        """print the current project info and version"""
        self.require_configured()
        pc = self.project_conf
        print("")
        print(f"Customer Number : {pc['customer_number']}")
        print(f"Project  Number : {pc['project_number']}")
        print(f"Site Name       : {pc['site_name']}")
        print(f"Staging Url     : https://{pc['stage_url']}")
        print(f"Db Driver       : {pc['db_driver']}")
        print(f"Project Version : {self.semver()}")
        print("")

    def cmd_package_release(self, ns=None):
        """create a gzip containg the project release"""
        self.require_configured(with_containers=True)
        pc = self.project_conf

        print("Current version is %s" % self.semver())
        val = self.prompt.ask_int("semver", 0, 2, 0)
        if int(val) == 0:
            pc['semver_major'] += 1
            pc['semver_minor'] = config['semver_minor']
            pc['semver_patch'] = config['semver_patch']
        elif int(val) == 1:
            pc['semver_minor'] += 1
            pc['semver_patch'] = config['semver_patch']
        else:
            pc['semver_patch'] += 1
        # dump the seed database
        self.cmd_seed_export()
        release_path = f"/data/release_{self.p_code}-{self.semver()}.tar.gz"
        # create archive of the /data/craft directory
        # maybe some directories could be escluded ?
        cmd = "tar -c /data/craft | gzip > %s" % release_path
        self.docker.exec(self.cms_container, cmd)
        # copy the archive locally
        self.docker.cp(self.cms_container, release_path, self.project_path)
        # remove the archive in the container
        cmd = f"rm {release_path}"
        self.docker.exec(self.cms_container, cmd)
        # save project conf
        self.write_file(self.config_path, json.dumps(self.project_conf, indent=2))

    def cmd_composer_update(self, ns=None):
        """run composer install on the target environment (experimental)"""
        self.require_configured(with_containers=True)
        command = """cd craft && composer update"""
        self.docker.exec(self.cms_container, command)

    def cmd_plugin_install(self, ns=None):
        """handles the command to install a plugin with composer in craft environment (@see plugin_install)"""
        self.plugin_install(ns.name)

    def plugin_install(self, plugin_name):
        """install a plugin with composer in craft environment (if not yet installed)"""
        self.require_configured(with_containers=True)
        # check if the package is already installed
        cmd = f"cd craft && composer show --name-only | grep {plugin_name} | wc -l"
        res = self.docker.exec(self.cms_container, cmd)
        if int(res) > 0:
            print("plugin %s installed" % plugin_name)
        else:
            # run composer install
            cmd = f"cd craft && composer require {plugin_name} --no-interaction"
            self.docker.exec(self.cms_container, cmd)
            # run craft install
            cmd = """craft/craft install/plugin %s """ % re.sub(r'^.*?/', '', plugin_name)
            self.docker.exec(self.cms_container, cmd)
        # get the list of plugins required for the project in conf
        cr = self.project_conf.get('composer_require', [])
        # if the plugin was not listed add it to the project
        if plugin_name not in cr:
            cr.append(plugin_name)
            self.project_conf['composer_require'] = cr
            # save project conf
            self.write_file(self.config_path, json.dumps(self.project_conf, indent=2))

    def cmd_plugin_remove(self, ns=None):
        """handles the command line command to uninstall a plugin with composer in craft environment @see plugin_remove"""
        self.plugin_remove(ns.name)

    def plugin_remove(self, plugin_name):
        """uninstall a plugin with composer in craft environment (if installed)"""
        self.require_configured(with_containers=True)
        # check if the package is already installed
        cmd = f"cd craft && composer show --name-only | grep {plugin_name} | wc -l"
        res = self.docker.exec(self.cms_container, cmd)
        if int(res) <= 0:
            print("plugin %s is not installed" % plugin_name)
        else:
            # run composer uninstall
            cmd = f"cd craft && composer remove {plugin_name} --no-interaction"
            self.docker.exec(self.cms_container, cmd)
        # get the list of plugins required for the project in conf
        cr = self.project_conf.get('composer_require', [])
        # if the plugin was not listed add it to the project
        if plugin_name in cr:
            cr.remove(plugin_name)
            self.project_conf['composer_require'] = cr
            # save project conf
            self.write_file(self.config_path, json.dumps(self.project_conf, indent=2))

    def cmd_schema_export(self, args=None):
        """export the schema using schematic"""
        self.require_configured(with_containers=True)
        cmd = f"/data/craft/craft schematic/export --file={args.file}"
        self.docker.exec(self.cms_container, cmd)
        print(f"schema export complete")

    def cmd_schema_import(self, args=None):
        """import the schema using schematic"""
        self.require_configured(with_containers=True)
        cmd = f"/data/craft/craft schematic/import --file={args.file}"
        self.docker.exec(self.cms_container, cmd)
        print(f"schema import complete")

    def cmd_open_staging(self, args=None):
        host = self.project_conf['stage_url']
        if args.all_pages:
            webbrowser.open_new_tab(f"https://{host}/db")
            webbrowser.open_new_tab(f"https://{host}/admin")
        webbrowser.open_new_tab(f"https://{host}")

    def cmd_open_dev(self, args=None):
        self.require_configured(with_containers=True)
        host = self.project_conf['local_url']
        if not args.front_only:
            webbrowser.open_new_tab(f"http://{host}/db")
            webbrowser.open_new_tab(f"http://{host}/admin")
        webbrowser.open_new_tab(f"http://{host}")


if __name__ == '__main__':
    cmds = [
        {
            'name': 'setup',
            'help': 'set up the application'
        },
        {
            'name': 'seed-import',
            'help': 'import the database-seed.sql',
            'args': [
                {
                    'names': ['-f', '--file'],
                    'help': 'path of the sql to import',
                    'default': '/data/craft/config/database-seed.sql'
                }
            ]
        },
        {
            'name': 'seed-export',
            'help': 'export the database-seed.sql',
            'args': [
                {
                    'names': ['-f', '--file'],
                    'help': 'path of produced sql',
                    'default': '/data/craft/config/database-seed.sql'
                }
            ]
        },
        {
            'name': 'info',
            'help': 'print the current project info and version'
        },
        {
            'name': 'local-start',
            'help': 'start the local docker environment'
        },
        {
            'name': 'local-stop',
            'help': 'stops the local docker environment'
        },
        {
            'name': 'local-teardown',
            'help': 'destroy the local docker environment'
        },
        {
            'name': 'restore',
            'help': 'restore a project that has been teardown, recreating the configurations'
        },
        {
            'name': 'package-release',
            'help': 'create a gzip containg the project release'
        },
        {
            'name': 'plugin-install',
            'help': 'install a plugin into craft',
            'args': [
                {
                    'names': ['name'],
                    'help': 'the name of the plugin to install, ex. craftcms/aws-s3',
                }
            ]

        },
        {
            'name': 'plugin-remove',
            'help': 'uninstall a plugin from craft',
            'args': [
                {
                    'names': ['name'],
                    'help': 'the name of the plugin to remove, ex. craftcms/aws-s3',
                }
            ]
        },
        {
            'name': 'schema-export',
            'help': 'export the craft schema',
            'args': [
                {
                    'names': ['-f', '--file'],
                    'help': 'path of the schema where to export',
                    'default': '/data/craft/config/schema.yml'
                }
            ]
        },
        {
            'name': 'schema-import',
            'help': 'import the craft schema',
            'args': [
                {
                    'names': ['-f', '--file'],
                    'help': 'path of the schemat to import',
                    'default': '/data/craft/config/schema.yml'
                }
            ]
        },
        {
            'name': 'open-staging',
            'help': 'open a browser tabs to staging env (public)',
            'args': [
                {
                    'names': ['-a', '--all-pages'],
                    'help': 'also open admin and adminer',
                    'action': 'store_true'
                }
            ]
        },
        {
            'name': 'open-dev',
            'help': 'open a browser tabs to dev env (public,admin,adminer)',
            'args': [
                {
                    'names': ['-f', '--front-only'],
                    'help': 'open only the public page',
                    'action': 'store_true'
                }
            ]
        },
    ]

    parser = argparse.ArgumentParser()
    parser.add_argument('-v', '--verbose', help='print verbose messages', action='store_true', default=False)
    subparsers = parser.add_subparsers(title="commands")
    subparsers.required = True
    subparsers.dest = 'command'
    # register all the commands
    for c in cmds:
        subp = subparsers.add_parser(c['name'], help=c['help'])
        # add the sub arguments
        for sa in c.get('args', []):
            subp.add_argument(*sa['names'],
                              help=sa['help'],
                              action=sa.get('action'),
                              default=sa.get('default'))

    args = parser.parse_args()

    c = Commander(args.verbose)
    # call the command with our args
    ret = getattr(c, 'cmd_{0}'.format(args.command.replace('-', '_')))(args)
    sys.exit(ret)
