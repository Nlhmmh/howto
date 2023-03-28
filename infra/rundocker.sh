#!/bin/sh

# docker pull mysql
# docker run -it --name howto-mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:latest
# docker exec -it howto-mysql bash -p
# mysql -u root -p -h 127.0.0.1

docker-compose down --remove-orphans --volumes
docker-compose up -d