# ZaliQL
A SQL-Based Framework for Drawing Causal Inference from Big Data ([Paper](https://drive.google.com/file/d/0B5MQIp52G7ohc0NSSEl0V19yclk/view))

# Demo
The only external dependency for ZaliQL is [Docker](https://docs.docker.com/install/#supported-platforms). It allows anyone with docker installed on their machine to spin up a containerized stack with all of the internal dependencies and demo data automatically installed.


To spin up the containerized stack, use `docker-compose`:
```bash
docker-compose -f docker/docker-compose.yml up -d --build
# OR
npm run docker
```

To verify the containers are successfully running on your host machine:
```bash
docker ps -a
# Should see something like...
# NAMES
# docker_python_1
# docker_db_1
# docker_angular_1
```

### These containers include:
- python: the python webserver (port 5000)
  - The python webserver is instantiated with the anaconda distribution packages on python version 3.6.4
- db: a postgres database (port 5434)
  - The postgres database is version 9.6 and comes pre-populated with demo data along with ZaliQL's and Madlib's function libraries
- angular: frontend client for interacting with the database functions (port 4201)
  - to view the frontend, navigate to `localhost:4201` in your web browser

### Considerations
- The motivation for the frontend client is to make it quick and easy to run a matchit calls in postgres and visualize the results
  - If you'd like to run the postgres functions directly, you can see examples in `backennd/db/examples`
- The motivation for using docker is to make it seamless to get a local version of ZaliQL running for demonstration
  - However, databases inside docker do not scale to large datasets
  - To use ZaliQL at scale:
    - Install the postgres extension [Madlib](http://madlib.apache.org/)
    - Add all of ZaliQL's functions to your postgres instance (`backend/db/functions`)

#### Other useful docker commands
Shortcuts to these docker commands can be found in root `package.json` (you'll need node/npm to use them)

To see the live-logs (or retroactive logs after a container crash) for one of the containers:
```bash
# python
docker-compose -f docker/docker-compose.yml logs -t -f python
# OR
npm run logs-python
# database
docker-compose -f docker/docker-compose.yml logs -t -f db
# OR
npm run logs-db
# NOTE: database logs messages are not output to console
# ssh into the database container and `cat /var/lib/pgsql/9.6/data/pg_log/logname.log`

# frontend
docker-compose -f docker/docker-compose.yml logs -t -f angular
```

To ssh into one of the containers using a bash interface:
```bash
# python
docker exec -it docker_python_1 bash
# OR
npm run ssh-python
# database
docker exec -it docker_db_1 bash
# OR
npm run ssh-db
# frontend
docker exec -it docker_angular_1 bash
# OR
npm run ssh-angular
```

To connect to the container database from a client on your host machine like `postico`:
- host: localhost:5432
- user: madlib
- password: password
- database: maddb

To shut down all of the dockers (useful for a hard reset of database functions/data):
```bash
docker-compose -f docker/docker-compose.yml down
# OR
npm run docker-down
```

To delete & clean up docker containers/volumes/networks:
```bash
# prune containers
docker rm $(docker ps -qa --no-trunc --filter "status=exited")
# prune volumes
docker volume rm $(docker volume ls -qf dangling=true)
# prune networks
docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')
# prune images
docker rmi $(docker images -q)
```
