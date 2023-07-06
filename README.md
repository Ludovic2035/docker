# KomMonitor Docker

For convenience, this repository provides various ready-to-use configuration files to get started quickly with KomMonitor in a Docker environment.

## Get started
For development purposes use the provided Docker Compose. To set up a first running instance of KomMonitor very quickly, follow the steps described below.  
### Start a Keycloak instance:
You'll find a Docker Compose file with a simple Keycloak configuration within the [./keycloak](./keycloak) directory. For developing purposes, this Keycloak configuration uses a H2 file database for persisting data. Just run `docker compose up` within [./keycloak](./keycloak). 

To use Keycloak for development purposes on your local machine, add Keycloak as an entry to your host file as described [here](./keycloak/addHostEntry.readme). Keycloak then will be available under http://keycloak:8080/.
### Configure Keycloak:
Keycloak has a preconfigured "KomMonitor" realm with several KomMonitor clients registered. However, you have to regenerate the client secrets for all of these components, since they won't be imported at startup time. These secrets later wil be used to configure the KomMonitor components. In addition, create a dummy user in the KomMonitor realm and assign the *kommonitor-creator* role.
### Configure KomMonitor
You have to adopt the configuration files within [./kommonitor/config](./kommonitor/config) to your current Keycloak setup. This means, put the regenerated client secrets in every single *.env file to the `KOMMONITOR_SWAGGER_UI_SECURITY_SECRET` and `KEYCLOAK_CREDENTIALS_SECRET` variables.
### Start KomMonitor: 
Run `docker compose up` from [./kommonitor](./kommonitor). This sets up all components of the KomMonitor stack via Docker. The Web client will be available via http://localhost:8084/.
### Start Portainer
If you wish to monitor all your Docker containers via [Portainer](https://www.portainer.io/) start an instance from the [./portainer](./portainer) directory.
## Production
Each component comes with an additional docker-compose.prod.yml file, which holds some specific configurations for running KomMonitor in production. These configuration files extend and may override the simple docker-compose.yml files.
To deploy one of the components in production mode, you have to run `docker compose -f .\docker-compose.yml -f .\docker-compose.prod.yml up` from the component's root directory. Make sure that you adopted all configuration files, which
are meant for production, for your environment.
