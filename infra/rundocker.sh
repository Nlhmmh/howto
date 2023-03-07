#!/bin/sh

# docker pull mysql
# docker run -it --name howto-mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:latest
# docker exec -it howto-mysql bash -p
# mysql -u root -p -h 127.0.0.1

docker-compose down --remove-orphans --volumes
docker-compose up -d
docker-compose exec db sh -c "chmod 0775 docker-entrypoint-initdb.d/initdb.sh"
docker-compose exec db sh -c "chmod 0775 docker-entrypoint-initdb.d/access.cnf"
# docker-compose exec db sh -c "./docker-entrypoint-initdb.d/initdb.sh"
docker-compose exec db sh -c "mysql -u root -p howto < /docker-entrypoint-initdb.d/main.sql"