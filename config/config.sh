#!/bin/sh

if [ "$KOMMONITOR_NAME" == "kommonitor-client-config" ]
then
    apk add gettext
    if [ -f /code/configStorage/webClientAppConfig.js ];
    then
        echo "Web Client App configuration already set."
    else
        echo "Set Web Client App configuration."
        envsubst < /code/templates/webClientAppConfig.js.template > /code/configStorage/webClientAppConfig.js
    fi
    if [ -f /code/configStorage/webClientKeycloakConfig.json ];
    then
        echo "Web Client Keycloak Config already set."
    else
        echo "Set Web Client Keycloak Config."
        envsubst < /code/templates/webClientKeycloakConfig.json.template > /code/configStorage/webClientKeycloakConfig.json
    fi
    npm start
fi

if [ "$KOMMONITOR_NAME" == "kommonitor-web-client" ]
then
    if [ -s /usr/share/nginx/html/config/config-storage-server.json ];
    then
        echo "Client Config Server configuration already set."
    else
        echo "Set Client Config Server configuration."
        envsubst < /code/templates/config-storage-server.json.template > /usr/share/nginx/html/config/config-storage-server.json
    fi
    nginx -g 'daemon off;'
fi
