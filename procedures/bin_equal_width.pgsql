-- do this with a simple query
-- first create the table (output_table)
--  -> throw an error if the output_table exists
-- append the needed columns
-- query the source_table, compute bins, insert into output_table
/*
INSERT INTO output_table
SELECT *, 
  width_bucket(distance::NUMERIC,min(distance::NUMERIC),max(distance::NUMERIC))
FROM source_table
*/

-- or create a view? test performance

CREATE OR REPLACE FUNCTION bin_equal_width(
  source_table ANYELEMENT,  -- input table name
  target_column TEXT,       -- input table column name
  output_table REGCLASS,    -- output table name
  num_bins INTEGER          -- prescribed number of bins
) RETURNS TEXT AS $func$
DECLARE
  commandString TEXT;
  newColumnName TEXT;
  minimum NUMERIC;
  maximum NUMERIC;
  currentContinuous NUMERIC;
  currentBin INTEGER;
  numRows INTEGER;
  minMaxRecord minMax;
BEGIN
  EXECUTE format('CREATE TABLE IF NOT EXISTS %stest_flight AS
  SELECT * FROM flight', );

  -- get the minimum and maximum of the target_column to compute the binWidth
  EXECUTE format('SELECT MIN(%s::NUMERIC) as minimum, MAX(%s::NUMERIC) as maximum FROM %s', target_column, target_column, pg_typeof(source_table)) INTO minMaxRecord;

  -- iterate through the rows in source_table to append bin column and insert into output_table
  numRows := 0;
  FOR source_table IN EXECUTE
    format('SELECT * FROM %s', pg_typeof(source_table))
  LOOP
    numRows := numRows + 1;
    EXECUTE 'SELECT ($1.' || quote_ident(target_column) || '::NUMERIC)' USING source_table INTO currentContinuous;
    SELECT width_bucket(currentContinuous, minMaxRecord.minimum, minMaxRecord.maximum, num_bins) INTO currentBin;
    RAISE NOTICE 'minMaxRecord: % ; distance: % ; currentBin: %', minMaxRecord, currentContinuous, currentBin;
    EXECUTE format('INSERT INTO %s SELECT $1.*', output_table)
    USING source_table;
  END LOOP;
  RETURN 'Successfully binned ' || numRows || ' rows into ' || num_bins || ' bins!';
END;
$func$ LANGUAGE plpgsql;

SELECT bin_equal_width(NULL::flight, 'distance', 'test_flight', 10);

-- Create type minMax
CREATE TYPE minMax AS (minimum NUMERIC, maximum NUMERIC);

DROP TABLE test_flight;

-- Create output_table if it does not exist
CREATE TABLE IF NOT EXISTS test_flight AS
SELECT * FROM flight;

-- Drop the binned column if it exists
ALTER TABLE test_flight
DROP COLUMN IF EXISTS ew_binned_distance;

-- Add the binned column to the output_table
ALTER TABLE test_flight
ADD COLUMN ew_binned_distance NUMRANGE;

SELECT COUNT(*) from flight
