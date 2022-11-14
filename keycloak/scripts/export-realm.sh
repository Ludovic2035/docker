#!/bin/bash
docker exec -it keycloak bash -c "QUARKUS_HTTP_HOST_ENABLED=false /opt/keycloak/bin/kc.sh export --dir /tmp/export --realm kommonitor --users realm_file"