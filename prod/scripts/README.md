# KomMonitor Managegment Scripts
This folder contains some utility scripts that facilitate bringing KomMonitor into production.
## Create Java Keystore
The Data Management API and Importer API need a Java keystore, which contains Keycloak server certificates to trust.
Creating the keystore from your host machine can lead to incompatibilities since the JDK on your host machine differs
from the one, which is used by the Docker containers. Therefore, it is recommended to create the Keystore from within
the Docker container by performing the following steps:
1. Place a PKCS12 certificate file into the [certs folder](../certs/).
2. Mount the [certs folder](../certs/) into the Data Management API container by adding `- ../certs:/etc/kommonitor/certs`
to the volume mappings within the [docker-compose.yml](../kommonitor/docker-compose.yml).
3. Start the KomMonitor Docker stack.
4. Execute the [create-keystore.sh](./create-keystore.sh) shell script, which will call the Keytool within the container
and creates a keystore.
5. As a result, the [certs folder](../certs/) should now contain a `keystore.jks` file.

## Keycloak Realm Export
Exporting a Realm from the Keycloak Console does not take into account secrets and user information. To create a deep export
for migration or backup purposes, [Keycloak provides a dedicated tool](https://www.keycloak.org/server/importExport).
The [export-realm.sh](./export-realm.sh) contains the command for executing it. Before executing it, make sure you have
added a volume mapping on `/tmp/export` (output dir within the container) into the
[Keycloak Docker Compose file](../keycloak/docker-compose.yml) and started it.