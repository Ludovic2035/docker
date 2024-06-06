# KomMonitor Docker

For convenience, this repository provides various ready-to-use configuration files to get started quickly with
KomMonitor in a Docker environment.

## General
You'll find Docker Compose files and configuration files for three different setups within this repository:  

[./dev](./dev): Sets up a first running instance of KomMonitor for development purposes. KomMonitor backend
services and the Web Client are reachable under their specific ports. No SSL/TLS.

[./dev-proxy](./dev-proxy): Also for development purposes but deploys an NGINX as proxy. KomMonitor backend
services and the Web Client are reachable under different subpaths via NGINX proxy. No SSL/TLS.

[./prod](./prod): Provides configurations for production purposes i.e., Keycloak and the NGINX proxy are configured
to support SSL/TLS and Keycloak makes use of an RDBMS.

All Docker Compose files make use of the environment files stored within [./config](./config). There are also some
`*.template` files, which are mounted into the NodeJS based containers (Web Client, Processing Engine, Processing
Scheduler). Env variables within these files are filled at startup time via `envsubst` command.

Each setup directory also contains an `.env` file, which contains setup specific values for environment variables
that acts as placeholder within all other `*.env` files within the [./config](./config) directory. 

## Get started
### Pre Installation Steps
#### Add Residential Area Geodata
The [Spatial Data Processor](https://github.com/KomMonitor/spatial-data-processor) component requires a shapefile
that provides geometries for residential areas. Before you start one of the stacks described below, you should
prepare such a Shapefile that holds residential areas for your region. Some regions may provide such datasets
as open data. E.g., North Rhine-Westfalia provides the Basis-DLM on its open data portal: https://www.opengeodata.nrw.de/produkte/geobasis/lm/akt/basis-dlm/.
The [configuration files]() in this repository are prepared for these Basis-DLM shapefiles reprojected in EPSG:4326. 

Note, that, up to now, the shapefile must be in EPSG:4326. Be sure that your datasets have this projection. Otherwise,
you have to reproject them. In future version, we plan to support other CRS by supporting on-the-fly reprojections.

### Development Setup
Both the [./dev](./dev) and [./dev-proxy](./dev-proxy) directory contain a ready-to use setup. You can deploy each
of the components via its Docker Compose file. Just follow the steps below.

#### 1. Start a Keycloak instance:
You'll find a Docker Compose file with a simple Keycloak configuration within the [./dev/keycloak](./dev/keycloak)
and [./dev-proxy/keycloak](./dev-proxy/keycloak) directory. For developing purposes, these Keycloak configuration
uses a H2 file database for persisting data. To start Keycloak just run `docker compose up` within
[./dev/keycloak](./dev/keycloak)or [./dev-proxy/keycloak](./dev-proxy/keycloak).  

Keycloak has a preconfigured "KomMonitor" realm with several KomMonitor clients preregistered.

**Important:** To use Keycloak for development purposes on your local machine, add Keycloak as an entry to your host
file as described [here](./dev/keycloak/addHostEntry.readme). Keycloak then will be available under
http://keycloak:8080/.

#### 2. Start KomMonitor: 
Run `docker compose up` from [./dev/kommonitor](./dev/kommonitor) or [./dev-proxy/kommonitor](./dev-proxy/kommonitor).
This sets up all components of the KomMonitor stack via Docker. 

**Non-proxy setup:** In case you use the non-proxy setup the Web client will be available via http://localhost:8084/.

**Proxy setup:** For the proxy setup the Web Client will be available via http://localhost/kommonitor after you have
deployed NGINX.

#### 3. Start NGINX proxy
To start the NGINX proxy run `docker compose up` from [./dev-proxy/nginx](./dev-proxy/nginx). This sets up an NGINX, 
which forwards certain subpath requests to the correct port under which the KomMonitor componets can be reached.

## Production Setup
The [./prod](./prod) directory aims to provide configuration files that are easy to adopt for a production deployment.
Although most configurations are ready-to-use, some manual actions are still required.

### SSL/TLS
Keycloak and KomMonitor have to be configured to support SSL/TLS in order to expose service endpoints via HTTPS. While 
Keycloak will be configured to use SSL/TLS by its own, the NGINX proxy provides SSL/TLS termination for all KomMonitor
 services and the Web Client. 

For SSL/TLS support you have to provide an SSL certificate as well as a private key. Just place the certificate and 
private key in PEM format within the [./prod/certs](./prod/certs) folder.

For setting up Keycloak and KomMonitor with SSL/TLS support for testing purposes on your local machine, you may
consider to create a self-signed certificate.

### Start and configure Keycloak
**1. Set up a production grade database**  
For production purposes Keycloak should use a production grade database. By default, Keycloak ist configured to use a
Postgres DB, which will be also deployed as Docker container. Please, change the default environment variables, which
contain sensitive data for DB accesss, such as DB name as well as the DB user and password within
[Docker Compose file](./prod/keycloak/docker-compose.yml).

If you'd rather like to use an already existing enterprise DB, just remove the `keycloak-db` service from the
[Docker Compose file](./prod/keycloak/docker-compose.yml) and provide certain configuration values for DB access
to the `KC_DB_*` environment variables.

For an in-depth guide about configuring Keycloak for production, please, have a look into the [official Keycloak 
documentation](https://www.keycloak.org/server/configuration-production).

**2. Configure the Keycloak hostname**
Depending on where you are going to deploy Keycloak, you have to change the `KC_HOSTNAME` variable. Just set the 
hostname of sever, where Keycloak will be reachable from. Consider the 
[Keycloak guide](https://www.keycloak.org/server/hostname) for further configurations.

**3. Start Keycloak**  
Run `docker compose up` within [./prod/keycloak]([./prod/keycloak]) to start Keycloak. At startup time, Keycloak will be
preconfigured by importing the `realm-export-kommonitor.json`, which contains a "KomMonitor" realm definition with all
KomMonitor components registered as client.

**4. Generate client secrets**  
The "KomMonitor" realm created at startup time has client definitions, which have some placeholder values as secrets. For
development purposes it is totally fine to leave the secrets as they are. However, for production setup you should. These
secrets also have to be provided to the KomMonitor components by setting the appropriate variables within
[./prod/kommonitor/.env](./prod/kommonitor/.env).

**5. Create a user**  
Within the "KomMonitor" realm create a first user for accessing restricted KomMonitor datasets and secrets. This user 
can be used to login into the KomMonitor Web Client. Assign the *kommonitor-creator* role to give the user admin rights.

### Start and configure KomMonitor
**1. Set up a production grade database**  
Per default the [./prod/kommonitor/docker-compose.yml](./prod/kommonitor/docker-compose.yml) sets up a PostGIS database
used as storage for the KomMonitor DataManagement API. Consider using an already existing enterprise database and remove 
the PostGIS service definition from the Docker Compose file.

**2. Configure KomMonitor**  
You have to adopt the environment variables within [./prod/kommonitor/.env](./prod/kommonitor/.env) file to
your current host, database and Keycloak configuration.

**3. Start KomMonitor**  
Run `docker compose up` from [./prod/kommonitor](./prod/kommonitor). This sets up all components of the KomMonitor stack
via Docker.

### Start NGINX
Start the NGINX proxy by running `docker compose up` from [./prod/nginx](./prod/nginx). This sets up an NGINX, 
which forwards certain subpath requests to the correct port under which the KomMonitor componets can be reached.

If you wish to change the subpaths, adapt the [NGINX configuration template](./prod/nginx/templates/default.conf.template).
But don't forget to also adapt the same paths within [./prod/kommonitor/.env](./prod/kommonitor/.env).

### Start Portainer
If you wish to monitor all your Docker containers via [Portainer](https://www.portainer.io/) start an instance from the
[./prod/portainer](./prod/portainer) directory via `docker compose up`.
