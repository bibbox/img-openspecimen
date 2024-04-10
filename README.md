[![Publish Docker image](https://github.com/bibbox/img-openspecimen/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/bibbox/img-openspecimen/actions/workflows/docker-publish.yml)

# OPENSPECIMEN image for BIBBOX application

Image repository for openspecimen app.

Check out the app repository [app-openspecimen](https://github.com/bibbox/app-openspecimen).

## Local Testing

```
docker network create bibbox-default-network
docker compose up --build
```
Test the openspecimen instance at http://localhost:9000/
