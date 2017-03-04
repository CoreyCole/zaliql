/*

SELECT *,
  max(id) OVER w subclass,
  max(T) OVER w as treated,
  min(T) OVER w as untreated
FROM source_table

CREATE MATERIALIZED VIEW



with subclasses as (
SELECT
	max(fid) AS subclass,
	max(cancelled) AS treated,
	min(cancelled) AS untreated,
	cancellationcode,
	ew_binned_distance,
	ew_binned_vism
FROM test_flight 
GROUP BY cancellationcode, ew_binned_distance, ew_binned_vism
Having max(cancelled)!= min(cancelled))
select * from 
subclasses ,test_flight where 
	 subclasses.cancellationcode = test_flight.cancellationcode
	AND subclasses.ew_binned_distance = test_flight.ew_binned_distance
	AND subclasses.ew_binned_vism = test_flight.ew_binned_vism;


SELECT * FROM pg_stats
WHERE tablename = 'flight';

with subclasses as (
SELECT
	max(fid) AS subclass,
	max(cancelled) AS treated,
	min(cancelled) AS untreated,
	cancellationcode,
	ew_binned_distance,
	ew_binned_vism
FROM test_flight 
GROUP BY cancellationcode, ew_binned_distance, ew_binned_vism
Having max(cancelled)!= min(cancelled))
select * from 
subclasses ,test_flight where 
	 subclasses.cancellationcode = test_flight.cancellationcode
	AND subclasses.ew_binned_distance = test_flight.ew_binned_distance
	AND subclasses.ew_binned_vism = test_flight.ew_binned_vism;
*/


CREATE OR REPLACE FUNCTION matchit(
  source_table TEXT,  -- input table name
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
BEGIN
  

  -- commandString := 'SELECT ' || quote_ident(treatment) || ',' || quote_ident(covariates)
  --   || ', COUNT(*) as matched_count'
  --   || ' FROM ' || pg_typeof(source_table)
  --   || ' GROUP BY ' || quote_ident(covariates) || ',' || quote_ident(treatment);
  -- FOR source_table IN EXECUTE commandString LOOP
  --   numGroups := numGroups + 1;
  --   EXECUTE 'INSERT INTO ' || quote_ident(output_table)
  --     || '(' || quote_ident(treatment) || ',' || quote_ident(covariates)
  --     || ',matched_count)'
  --     || ' SELECT '
  --     || '$1.' || quote_ident(treatment) || ', $1.' || quote_ident(covariates)
  --     USING source_table;
  --     -- || ',$1.matched_count' USING source_table;
  -- END LOOP;
  -- RETURN 'Successfully grouped ' || numGroups || ' distinct records'
  --   || ' with ' || numDiscarded || ' discarded records';
END;
$func$ LANGUAGE plpgsql;

SELECT matchit('test_flight', 'cancelled', 'cancellationcode ew_binned_distance ew_binned_vism', 'test_flight', '', '', '', false);

DROP FUNCTION matchit(anyelement,text,text,text,text,text,text,boolean);
