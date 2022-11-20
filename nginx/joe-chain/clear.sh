docker kill $(docker ps -q)
docker rm -f $(docker ps -a -q)