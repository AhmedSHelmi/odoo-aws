#!/bin/bash
# Script to clean up Docker containers, images, and volumes

docker container stop $(docker container ls -aq)
docker container rm $(docker container ls -aq)
docker image rm $(docker image ls -q)
docker volume rm $(docker volume ls -q)
