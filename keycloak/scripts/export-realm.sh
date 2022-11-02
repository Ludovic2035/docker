#!/bin/bash
docker exec -it keycloak bash -c "/opt/keycloak/bin/kc.sh export --dir /tmp/export --realm kommonitor --users realm_file"