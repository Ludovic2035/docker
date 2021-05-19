# Docker Keycloak Setup
This repo contains a docker-compose.yml for setting up a Keycloak instance via Docker relying on a H2 in-memeory database. Feel free to adopt the configurations for your own needs.
## Configuration
You'll find an in-depth documentation for the Keycloak Docker image at https://github.com/keycloak/keycloak-containers/blob/master/server/README.md
## Customization
The Docker configuration in this repository comes with a minimal customized theme, including KomMonitor related terms of use. You'll find it in the [./themes](./themes) directory.
The customized theme will be injected into the Docker container via volume binding. For extended customizations, please refer to the official [Keycloak documentation](https://www.keycloak.org/docs/latest/server_development/#_themes).
