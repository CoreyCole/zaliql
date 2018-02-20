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

