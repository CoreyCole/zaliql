DROP MATERIALIZED VIEW IF EXISTS demo_data_1000;

CREATE OR REPLACE FUNCTION is_low_pressure(
  pressurem NUMERIC
) RETURNS BIT AS $func$
DECLARE
  lowPressure NUMERIC;
  highPressure NUMERIC;
BEGIN
  lowPressure = 1009.14;
  highPressure = 1022.69;
  IF pressurem < lowPressure THEN
    RETURN 1;
  ELSIF pressurem > highPressure THEN
    RETURN 0;
  ELSE
    RETURN NULL;
  END IF; 
END;
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_low_visibility(
  vism NUMERIC
) RETURNS BIT AS $func$
DECLARE
  lowVisibility NUMERIC;
BEGIN
  lowVisibility = 1.0;
  IF vism < lowVisibility THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END;
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_heavy_snow(
  snow BOOLEAN,
  precipm NUMERIC
) RETURNS BIT AS $func$
DECLARE
  minPrecipm NUMERIC;
BEGIN
  minPrecipm = 0.3;
  IF (snow AND precipm > minPrecipm) THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END;
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_high_wspdm(
  wspdm NUMERIC
) RETURNS BIT AS $func$
DECLARE
  highSpeed NUMERIC;
  lowSpeed NUMERIC;
BEGIN
  highSpeed = 40.0;
  lowSpeed = 20.0;
  IF wspdm > highSpeed THEN
    RETURN 1;
  ELSIF wspdm < lowSpeed THEN
    RETURN 0;
  ELSE
    RETURN NULL;
  END IF;
END;
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cast_bit(
  data TEXT
) RETURNS BIT AS $func$
BEGIN
  RETURN data::NUMERIC::INTEGER::BIT;
  EXCEPTION
    WHEN invalid_text_representation THEN
      RAISE NOTICE 'caught invalid input syntax for type numeric: "false"';
      IF data::BOOLEAN THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
END;
$func$ LANGUAGE plpgsql;

CREATE MATERIALIZED VIEW demo_data_1000 AS
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
  round(depdelay::NUMERIC) AS depdelay,
  cast_bit(depdel15) AS depdel15,
  fid::INTEGER,
  code::TEXT,
  cast_bit(fog) AS fog,
  cast_bit(hail) AS hail,
  hour::INTEGER,
  hum::INTEGER,
  precipm::NUMERIC,
  pressurem::NUMERIC,
  is_low_pressure(pressurem::NUMERIC) AS lowpressure,
  cast_bit(rain) AS rain,
  cast_bit(snow) AS snow,
  is_heavy_snow(snow::BOOLEAN, precipm::NUMERIC) AS heavysnow,
  tempm::NUMERIC,
  cast_bit(thunder) AS thunder,
  vism::NUMERIC,
  is_low_visibility(vism::NUMERIC) AS lowvisibility,
  wspdm::NUMERIC,
  is_high_wspdm(wspdm::NUMERIC) AS highwindspeed
FROM demo_test_1000 WITH DATA;
