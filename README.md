# Consul Installer

Consul Installer is a Rails app that enables to install Consul through a web interface. 

The Consul installer has been created by [Populate](http://populate.tools), a design and technology studio around civic engagement. See https://github.com/PopulateTools for other tools.

The main use case for Consul Installer is when you need to install various Consuls in the same infrastructure and do it through a web interface (ie. someone who is not a developer can do it).

## Main features

- Consul Installer allows to specificy the available target machines where Consuls will be installed, be it one or more servers. You can specify several roles.
- Allows to create automatically sites by specifying a few parameters, such as the host name and the server that will run the site.
- Allows to update servers using ansible roles automatically
- Allows automatic deploys of new versions of the code.
- Tracks an audit log of all the actions performed by users

## Requirements

It has been tested and is in production use under CentOS servers using Ansible and Ruby Capistrano.

## Installation

Consul installer is a normal Rails application. It requires:

- CentOS 7
- Ruby >= 2.3.2
- PostgreSQL
- Ansible

### Development

In development you can install it as a normal Rails application or try it using Vagrant. There's a
`Vagrantfile` in `ansible/` folder.

You can even install it in your laptop and use remote servers to install Consul. This is how we
worked on it during the development, using small instances of Linode created and removed via the
API, to simulate the production servers were Consul will run.

### Production

In production you can use an Ansible role to install it. Check `ansible/site-installer.yml` and
adapt it to your needs.

## Usage

### Setup

Before running the installer you need to adapt the roles to your target servers. The installer is
divided in three roles: web, app and db. These roles can be different servers or the same server.

You'll need to update the inventory:

- ansible/inventories/production

### Application usage

#### Server setup

The first step is to setup a server in a role. Add new server instances via the UI and run the setup
button. This will install all the packages and dependencies according to the role.

Internally, this step executes `ansible/consult_servers.yml`.

#### Consul instance setup and configuration

Once the servers are up and ready it's time to configure the consul instance with these options:

- name
- repository URL
- host
- base path: the path to the application in the server
- server to run each of the roles
- rails environment
- census api username
- census api password

After saving these settings run what we call "Site setup" which will create automatically the
folders in the server, the database with new credentials, a rails secret key base...

#### Deploy

When the instance is configured the deploy option will be available. A deploy just runs internally a
deploy using Capistrano to the servers where the instance is configured.

## Caveats

There are some caveats still pending to be solved:

- removing a site
- removing a server

These tasks must be performed manually for the moment.

## Support

Please open an issue. 

# Credits

The Consul installer has been created by [Populate](http://populate.tools). This notice should be kept in any derivative work as stated in the [license](LICENSE-AGPLv3.txt).
