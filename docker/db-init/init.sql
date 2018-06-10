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
DROP TABLE lalonde;

-- SFO flights
CREATE TABLE flights_weather_sfo (
  fid SERIAL primary key,
  carrierid INTEGER,
  carrier TEXT,
  airport TEXT,
  dest TEXT,
  yyear INTEGER,
  quarter INTEGER,
  month INTEGER,
  dayofweek INTEGER,
  hour INTEGER,
  crsdeptime TEXT,
  depdelay NUMERIC,
  depdel15 INTEGER,
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
COPY flights_weather_sfo (
  fid,
  carrierid,
  carrier,
  airport,
  dest,
  yyear,
  quarter,
  month,
  dayofweek,
  hour,
  crsdeptime,
  depdelay,
  depdel15,
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
) FROM '/db/data/flights-weather-sfo.csv' CSV HEADER;

-- SFO flights split into two tables
CREATE TABLE flights_sfo AS
SELECT fid, carrierid, carrier, airport, dest, yyear, quarter, month, dayofweek, hour, crsdeptime, depdelay, depdel15, wid
FROM flights_weather_sfo
ORDER BY fid;
CREATE TABLE weather_sfo AS
SELECT wid, fog, hail, hum, precipm, pressurem, lowpressure, rain, snow, heavysnow, tempm, thunder, vism, lowvisibility, wspdm, highwindspeed 
FROM flights_weather_sfo
ORDER BY wid;
