CREATE OR REPLACE FUNCTION matchit(
  source_table ANYELEMENT,  -- input table name
  treatment TEXT,           -- treatment column name
  covariates TEXT,          -- comma-separated covariate column names
  output_table TEXT,        -- output table name
  method TEXT,              -- matching method, default "nearest"
  method_input TEXT,        -- (optional) matching method args
  discard TEXT,             -- discard units outside distance measure, default "none"
  reestimate BOOLEAN        -- reestimate distance measure after discarding units
) RETURNS TEXT AS $func$
DECLARE
  commandString TEXT;
  numGroups INTEGER;
  numDiscarded INTEGER;
BEGIN
  commandString := 'SELECT ' || quote_ident(treatment) || ',' || quote_ident(covariates)
    || ', COUNT(*) as matched_count'
    || ' FROM ' || pg_typeof(source_table)
    || ' GROUP BY ' || quote_ident(covariates) || ',' || quote_ident(treatment);
  FOR source_table IN EXECUTE commandString LOOP
    numGroups := numGroups + 1;
    EXECUTE 'INSERT INTO ' || quote_ident(output_table)
      || '(' || quote_ident(treatment) || ',' || quote_ident(covariates)
      || ',matched_count)'
      || ' SELECT '
      || '$1.' || quote_ident(treatment) || ', $1.' || quote_ident(covariates)
      USING source_table;
      -- || ',$1.matched_count' USING source_table;
  END LOOP;
  RETURN 'Successfully grouped ' || numGroups || ' distinct records'
    || ' with ' || numDiscarded || ' discarded records';
END;
$func$ LANGUAGE plpgsql;

SELECT matchit(NULL::flight, 'rain', 'icon', 'test_flight', '', '', '', false);

DROP TABLE test_flight;

-- Create output_table if it does not exist
CREATE TABLE IF NOT EXISTS test_flight
(LIKE flight INCLUDING ALL);

-- Drop the count column if it exists
ALTER TABLE test_flight
DROP COLUMN IF EXISTS matched_count;

-- Add the count column to the output_table
ALTER TABLE test_flight
ADD COLUMN matched_count INTEGER;

SELECT * FROM test_flight;

DROP FUNCTION matchit(anyelement,text,text,text,text,text,text,boolean);
