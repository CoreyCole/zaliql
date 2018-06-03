#!/usr/bin/env bash

su --login postgres --command "/usr/pgsql-9.6/bin/postgres -D /var/lib/pgsql/9.6/data -p 5432" &
ps aux 

until pg_isready -h localhost -p 5432; do
  echo "Please wait for postgres docker container to finish initializing . . ."
  sleep 1
done

su --login postgres --command "/usr/pgsql-9.6/bin/psql -d maddb -f /docker-entrypoint-initdb.d/init.sql"

for filename in /db/functions/*.pgsql; do
  su --login postgres --command "/usr/pgsql-9.6/bin/psql -d maddb -f ${filename}"
done
