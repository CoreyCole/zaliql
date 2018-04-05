TODO:
- get demo flight data in docker `flights_weather_demo`
- test all functions in readme
  - test multi-level-treatment matchit with carrier treatment

# ZaliSQL
A SQL-Based Framework for Drawing Causal Inference from Big Data
### Table of Contents
- [Demo](https://gitlab.cs.washington.edu/bsalimi/ZaliSQL#Demo)
- [Preprocessing](https://gitlab.cs.washington.edu/bsalimi/ZaliSQL#Preprocessing)
- [Matching](https://gitlab.cs.washington.edu/bsalimi/ZaliSQL#Matching)
- [Analysis](https://gitlab.cs.washington.edu/bsalimi/ZaliSQL#Analysis)

# Demo
The only external dependency for ZaliQL is [Docker](https://docs.docker.com/install/#supported-platforms). It allows anyone with docker installed on their machine to spin up a containerized stack with all of the internal dependencies and demo data automatically installed.

### These containers include:
- app: the python webserver (port 5000)
  - The python webserver is instantiated with the anaconda distribution packages on python version 3.6.4
- db: a postgres database (port 5434)
  - The postgres database is version 9.6 and comes pre-populated with demo data along with ZaliQL's and Madlib's function libraries
- redis: an in-memory cache for certain user experience features

To spin up the containerized stack, use `docker-compose`:
```bash
docker-compose -f backend/docker/docker-compose.yml up -d --build
# NOTE: this takes some time, message "localhost:5432 - rejecting connections" is expected
```

To see what containers are running on your host machine:
```bash
docker ps -a
# Should see something like...
# NAMES
# docker_app_1
# docker_db_1
# docker_redis_1
```

To see the live-logs (or retroactive logs after a container crash) for one of the containers:
```bash
# python
docker-compose -f backend/docker/docker-compose.yml logs -t -f app
# database
docker-compose -f backend/docker/docker-compose.yml logs -t -f db
# NOTE: database logs messages are not output to console
# ssh into the database container and `cat /var/lib/pgsql/9.6/data/pg_log/logname.log`
```

To ssh into one of the containers using a bash interface:
```bash
# python
docker exec -it docker_app_1 bash
# database
docker exec -it docker_db_1 bash
```

To connect to the container database from a client on your host machine like `postico`:
- host: localhost:5432
- user: madlib
- password: password
- database: maddb

To shut down all of the dockers (useful for a hard reset of database functions/data):
```bash
docker-compose -f backend/docker/docker-compose.yml down
```
