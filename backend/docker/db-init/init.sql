-- instantiate lalonde demo data
CREATE TABLE lalonde(
  id TEXT,
  treat INTEGER,
  age INTEGER,
  educ INTEGER,
  black INTEGER,
  hispan INTEGER,
  married INTEGER,
  nodegree INTEGER,
  re74 NUMERIC,
  re75 NUMERIC,
  re78 NUMERIC
);
COPY lalonde (
  id,
  treat,
  age,
  educ,
  black,
  hispan,
  married,
  nodegree,
  re74,
  re75,
  re78
) FROM '/db/data/lalonde.csv' CSV HEADER;
CREATE TABLE lalonde_demo (
  pk serial primary key,
  id TEXT,
  treat INTEGER,
  age INTEGER,
  educ INTEGER,
  black INTEGER,
  hispan INTEGER,
  married INTEGER,
  nodegree INTEGER,
  re74 NUMERIC,
  re75 NUMERIC,
  re78 NUMERIC
);
CREATE SEQUENCE lalonde_demo_id_seq;
INSERT INTO lalonde_demo 
SELECT 
  nextval('lalonde_demo_id_seq'),
  id,
  treat,
  age,
  educ,
  black,
  hispan,
  married,
  nodegree,
  re74,
  re75,
  re78
FROM lalonde
ORDER BY id asc;

-- instantiate flights & weather demo data
CREATE TABLE weather_demo (
  wid SERIAL primary key,
  fog INTEGER,
  hail INTEGER,
  hum INTEGER,
  precipm NUMERIC,
  pressurem NUMERIC,
  lowpressure INTEGER,
  rain INTEGER,
  snow INTEGER,
  heavysnow INTEGER,
  tempm NUMERIC,
  thunder INTEGER,
  vism NUMERIC,
  lowvisibility INTEGER,
  wspdm NUMERIC,
  highwindspeed INTEGER
);
CREATE TABLE flights_demo (
  fid SERIAL primary key,
  yyear INTEGER,
  quarter INTEGER,
  month INTEGER,
  dayofweek INTEGER,
  hour INTEGER,
  carrierid INTEGER,
  carrier TEXT,
  dest TEXT,
  crsdeptime TEXT,
  depdelay NUMERIC,
  depdel15 INTEGER,
  airport TEXT,
  wid SERIAL references weather_demo (wid)
);
CREATE TABLE flights_weather_demo (
  fid SERIAL primary key,
  yyear INTEGER,
  quarter INTEGER,
  month INTEGER,
  dayofweek INTEGER,
  hour INTEGER,
  carrierid INTEGER,
  carrier TEXT,
  dest TEXT,
  crsdeptime TEXT,
  depdelay NUMERIC,
  depdel15 INTEGER,
  airport TEXT,
  wid SERIAL,
  fog INTEGER,
  hail INTEGER,
  hum INTEGER,
  precipm NUMERIC,
  pressurem NUMERIC,
  lowpressure INTEGER,
  rain INTEGER,
  snow INTEGER,
  heavysnow INTEGER,
  tempm NUMERIC,
  thunder INTEGER,
  vism NUMERIC,
  lowvisibility INTEGER,
  wspdm NUMERIC,
  highwindspeed INTEGER
);
COPY weather_demo (
  wid,
  fog,
  hail,
  hum,
  precipm,
  pressurem,
  lowpressure,
  rain,
  snow,
  heavysnow,
  tempm,
  thunder,
  vism,
  lowvisibility,
  wspdm,
  highwindspeed
) FROM '/db/data/weather.csv' CSV HEADER;
COPY flights_demo (
  fid,
  yyear,
  quarter,
  month,
  dayofweek,
  hour,
  carrierid,
  carrier,
  dest,
  crsdeptime,
  depdelay,
  depdel15,
  airport,
  wid
) FROM '/db/data/flights.csv' CSV HEADER;
INSERT INTO flights_weather_demo
SELECT
  fid,
  yyear,
  quarter,
  month,
  dayofweek,
  hour,
  carrierid,
  carrier,
  dest,
  crsdeptime,
  depdelay,
  depdel15,
  airport,
  wid,
  fog,
  hail,
  hum,
  precipm,
  pressurem,
  lowpressure,
  rain,
  snow,
  heavysnow,
  tempm,
  thunder,
  vism,
  lowvisibility,
  wspdm,
  highwindspeed
FROM flights_demo
JOIN weather_demo using(wid);
