ALTER MATERIALIZED VIEW demo_data_5000000 RENAME TO demo_data_bit_5000000;

CREATE MATERIALIZED VIEW demo_data_5000000 AS
SELECT
  yyear::INTEGER,
  quarter::INTEGER,
  month::INTEGER,
  dayofweek::INTEGER,
  uniquecarrier::TEXT,
  airlineid::INTEGER,
  carrier::TEXT,
  dest::TEXT,
  crsdeptime::TEXT,
  depdelay::NUMERIC,
  depdel15::INTEGER,
  fid::INTEGER,
  code::TEXT,
  fog::INTEGER,
  hail::INTEGER,
  hour::INTEGER,
  hum::INTEGER,
  precipm::NUMERIC,
  pressurem::NUMERIC,
  lowpressure::INTEGER,
  rain::INTEGER,
  snow::INTEGER,
  heavysnow::INTEGER,
  tempm::NUMERIC,
  thunder::INTEGER,
  vism::NUMERIC,
  lowvisibility::INTEGER,
  wspdm::NUMERIC,
  highwindspeed::INTEGER
FROM demo_data_bit_5000000 WITH DATA;