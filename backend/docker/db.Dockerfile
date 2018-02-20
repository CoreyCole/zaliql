FROM gmodena/centos-pgsql-madlib

COPY ./db/ /db/
COPY ./docker/db-init/ /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init.sql
RUN chmod +x /docker-entrypoint-initdb.d/init.sh
RUN /docker-entrypoint-initdb.d/init.sh

# CMD ["su", "--login", "postgres"]
# ENV POSTGRESQL_USER 'zaliql'
# ENV POSTGRESQL_PASSWORD 'password'
# ENV POSTGRESQL_DATABASE 'lalonde'

# COPY ./docker/db-init/init.sql /docker-entrypoint-initdb.d/init.sql

# CMD ["su", "--login", "postgres", "psql", "dbname='maddb' user='madlib' password='password' host='localhost'", "-f", "/docker-entrypoint-initdb.d/init.sql"]

    # restart: always
    # environment:
    #   POSTGRES_DB: lalonde
    #   POSTGRES_USER: zaliql
    #   POSTGRES_PASSWORD: password
    #   PGDATA: ./db-init/
    # ports:
    #   - 5433:5432
    # volumes:
    #   - ../db/:/db/
    #   - ./db-init/:/docker-entrypoint-initdb.d/