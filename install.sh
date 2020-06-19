#!/bin/bash

# update git
git pull

# stop all containers
docker ps -q | xargs -L1 docker stop
# delete all stopped containers
docker rm -vf $(docker ps -a -q)
# delete unused networks
docker network prune -f
# delete all images
docker rmi -f $(docker images | grep "sormas-stats" | awk '{print $3}')

# build images
docker-compose build
# start container in the background (-d flag)
docker-compose up -d

exit 0
