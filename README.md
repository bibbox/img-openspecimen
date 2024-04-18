[![Publish Docker image](https://github.com/bibbox/img-openspecimen/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/bibbox/img-openspecimen/actions/workflows/docker-publish.yml)
![Static Badge](https://img.shields.io/badge/Docker-bibbox%2Fopenspecimen-blue)

# OPENSPECIMEN image for BIBBOX application

Image repository for openspecimen app.

Check out the app repository [app-openspecimen](https://github.com/bibbox/app-openspecimen).

## Local Testing

```
mkdir data
mkdir data/openspecimen
mkdir data/openspecimen/data
mkdir data/openspecimen/plugins
chmod a+w -R data/openspecimen 
docker network create bibbox-default-network
docker compose up --build
```
Test the openspecimen instance at http://localhost:9000/openspecimen/#/
