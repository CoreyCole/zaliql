FROM gmodena/centos-pgsql-madlib

COPY ./backend/db/ /db/
COPY ./docker/db-init/ /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init.sql
RUN chmod +x /docker-entrypoint-initdb.d/init.sh
RUN /docker-entrypoint-initdb.d/init.sh
