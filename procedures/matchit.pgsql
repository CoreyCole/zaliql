/*
CREATE MATERIALIZED VIEW test_flight AS
with subclasses as (
	SELECT
		max(fid) AS subclass,
		max(thunder) AS treated,
		min(thunder) AS untreated,
		dewpti,
		dewptm,
		fog,
		hail,
		hum,
		precipm,
		pressurei,
		pressurem,
		rain,
		snow,
		tempi,
		tempm,
		tornado,
		visi,
		vism,
		wspdi,
		wspdm
	FROM demo_test_100000
	GROUP BY
		dewpti,
		dewptm,
		fog,
		hail,
		hum,
		precipm,
		pressurei,
		pressurem,
		rain,
		snow,
		tempi,
		tempm,
		tornado,
		visi,
		vism,
		wspdi,
		wspdm
	HAVING max(thunder) !=  min(thunder)
) SELECT * FROM subclasses, demo_test_100000 dt WHERE
	subclasses.dewpti = dt.dewpti
	AND subclasses.dewptm = dt.dewptm
	AND subclasses.fog = dt.fog
	AND subclasses.hail = dt.hail
	AND subclasses.hum = dt.hum
	AND subclasses.precipm = dt.precipm
	AND subclasses.pressurei = dt.pressurei
	AND subclasses.pressurem = dt.pressurem
	AND subclasses.rain = dt.rain
	AND subclasses.snow = dt.snow
	AND subclasses.tempi = dt.tempi
	AND subclasses.tempm = dt.tempm
	AND subclasses.tornado = dt.tornado
	AND subclasses.visi = dt.visi
	AND subclasses.vism = dt.vism
	AND subclasses.wspdi = dt.wspdi
	AND subclasses.wspdm = dt.wspdm
WITH DATA;
*/


CREATE OR REPLACE FUNCTION matchit(
  source_table TEXT,        -- input table name
  primary_key TEXT,         -- source table's primary key
  treatment TEXT,           -- treatment column name
  covariates TEXT,          -- space separated covariate column names
  output_table TEXT,        -- output table name
  method TEXT,              -- matching method, default "cem"
  method_input TEXT,        -- (optional) matching method args, default ''
  discard TEXT,             -- discard units outside distance measure, default "none"
  reestimate BOOLEAN        -- reestimate distance measure after discarding units
) RETURNS TEXT AS $func$
DECLARE
  commandString TEXT;
  numGroups INTEGER;
  numDiscarded INTEGER;
  covariatesArr TEXT[];
  covariate TEXT;
BEGIN
  SELECT regexp_split_to_array(covariates, '\s+') INTO covariatesArr;

  commandString := 'WITH subclasses as (SELECT'
    || ' max(' || quote_ident(primary_key) || ') AS subclass,'
    || ' max(' || quote_ident(treatment) || '::NUMERIC) AS treated,'
    || ' min(' || quote_ident(treatment) || '::NUMERIC) AS untreated';
  
  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString = commandString || ', ' || quote_ident(covariate) || ' AS ' || quote_ident(covariate) || '_matched';
  END LOOP;

  commandString = commandString || ' FROM ' || quote_ident(source_table) || ' GROUP BY ';

  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString = commandString || quote_ident(covariate) || '_matched, ';
  END LOOP;

  -- use substring here to chop off last comma
  commandString = substring( commandString from 0 for (char_length(commandString) - 1) );
    
  commandString = commandString || ' HAVING max(' || quote_ident(treatment) || '::NUMERIC) != min(' || quote_ident(treatment) || '::NUMERIC)'
    || ') SELECT * FROM subclasses, ' || quote_ident(source_table) || ' st WHERE';

  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString = commandString || ' subclasses.' || quote_ident(covariate) || '_matched = st.' || quote_ident(covariate) || ' AND';
  END LOOP;

  -- use substring here to chop off last `AND`
  commandString = substring( commandString from 0 for (char_length(commandString) - 3) );

  EXECUTE format('DROP MATERIALIZED VIEW IF EXISTS %s', output_table);

  commandString = 'CREATE MATERIALIZED VIEW ' || output_table
    || ' AS ' || commandString || ' WITH DATA;';
  RAISE NOTICE '%', commandString;
  EXECUTE commandString;

  RETURN 'Match successful and materialized in ' || output_table || '!';
END;
$func$ LANGUAGE plpgsql;

SELECT matchit('demo_test_1000', 'fid', 'thunder', 'dewpti dewptm fog hail hum precipm pressurei pressurem rain snow tempi tempm tornado visi vism wspdi wspdm', 'test_flight', '', '', '', false);

DROP FUNCTION matchit(text,text,text,text,text,text,text,boolean);

-- ERROR:  column "dewpti" specified more than once
/*
CREATE MATERIALIZED VIEW test_flight AS 
  WITH subclasses as (
    SELECT max(fid) AS subclass, max(thunder) AS treated, min(thunder) AS untreated,
      dewpti, dewptm, fog, hail, hum, precipm, pressurei, pressurem, rain, snow, tempi, tempm, tornado, visi, vism, wspdi, wspdm 
    FROM demo_test_1000 GROUP BY 
      dewpti, dewptm, fog, hail, hum, precipm, pressurei, pressurem, rain, snow, tempi, tempm, tornado, visi, vism, wspdi, wspdm,
    HAVING max(thunder) != min(thunder)
  ) 
  SELECT * FROM subclasses, demo_test_1000 st 
  WHERE 
  subclasses.dewpti = st.dewpti AND
  subclasses.dewptm = st.dewptm AND
  subclasses.fog = st.fog AND
  subclasses.hail = st.hail AND
  subclasses.hum = st.hum AND 
  subclasses.precipm = st.precipm AND 
  subclasses.pressurei = st.pressurei AND 
  subclasses.pressurem = st.pressurem AND 
  subclasses.rain = st.rain AND 
  subclasses.snow = st.snow AND 
  subclasses.tempi = st.tempi AND 
  subclasses.tempm = st.tempm AND 
  subclasses.tornado = st.tornado AND 
  subclasses.visi = st.visi AND 
  subclasses.vism = st.vism AND 
  subclasses.wspdi = st.wspdi AND 
  subclasses.wspdm = st.wspdm 
WITH DATA;
*/