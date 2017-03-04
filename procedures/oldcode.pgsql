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
  source_table TEXT,    -- input table name
  target_columns TEXT,  -- space separated list of continuous column names to bin
  output_table TEXT,    -- output table name
  num_bins TEXT      -- space separated list of prescribed number of bins, correspond to target_columns
) RETURNS TEXT AS $func$
DECLARE
  targetColumnArr TEXT[];
  numBinsArr TEXT[];
  i INTEGER;
  targetColumn TEXT;
  columnType TEXT;
  binningString TEXT;
  commandString TEXT;
  newColumnName TEXT;
  minimum NUMERIC;
  maximum NUMERIC;
  currentContinuous NUMERIC;
  currentBin INTEGER;
  numRows INTEGER;
  minMaxString TEXT;
  minMaxRes minMax;
  minMaxRecordArr minMax[];
BEGIN
  SELECT regexp_split_to_array(target_columns, '\s+') INTO targetColumnArr;
  SELECT regexp_split_to_array(num_bins, '\s+') INTO numBinsArr;
  -- check type of target columns to make sure they are numeric
  -- FOREACH targetColumn IN ARRAY targetColumnArr LOOP
  --   commandString := 'SELECT data_type FROM information_schema.columns WHERE'
  --     || ' table_name = ' || quote_ident(source_table)
  --     || ' AND column_name = ' || quote_ident(targetColumn);
  --   EXECUTE commandString INTO columnType;
  --   RAISE NOTICE 'column type: %', columnType;
  -- END LOOP;
  
  minMaxString := '';
  FOREACH targetColumn IN ARRAY targetColumnArr LOOP
    minMaxString = minMaxString || ', MIN(' || targetColumn || '::NUMERIC) as min_' || targetColumn || ','
      || ' MAX(' || targetColumn || '::NUMERIC) as max_' || targetColumn;
  END LOOP;

  -- use substring here to chop off the first comma in minMaxString (otherwise syntax error)
  commandString := 'SELECT ' || substring( minMaxString from 3 for ( char_length(minMaxString)) )
    || ' FROM ' || quote_ident(source_table);
  RAISE NOTICE 'full minMax cmd: %', commandString;
  DROP TABLE IF EXISTS minMaxRecord;
  EXECUTE format('CREATE TEMP TABLE minMaxRecord AS %s', commandString);

  -- minMaxRecordArr minMax ARRAY[array_upper(targetColumnArr, 1)];
  -- FOREACH targetColumn IN ARRAY targetColumnArr LOOP
  --   EXECUTE format('SELECT MIN(%s::NUMERIC) as minimum, MAX(%s::NUMERIC) as maximum FROM %s', targetColumn, targetColumn, source_table) INTO minMaxRecord;
  --   RAISE NOTICE 'min:% max:%', minMaxRecord.minimum, minMaxRecord.maximum;
  --   minMaxRecordArr[i] = minMaxRecord;
  --   i = i + 1;
  -- END LOOP;

  -- build up minMax string
  -- dynamic numBins per targetColumn
  -- need to look into why aggregate function width_bucket takes so much time
  -- look into bitmax indexes on the binned columns
  binningString := '';
  i := 1;
  FOREACH targetColumn IN ARRAY targetColumnArr LOOP
    EXECUTE format('SELECT min_%s as minimum, max_%s as maximum FROM minMaxRecord', targetColumn, targetColumn) INTO minMaxRes;
    RAISE NOTICE 'min:% max:%', minMaxRes.minimum, minMaxRes.maximum;
    binningString = binningString || ', width_bucket(' || quote_ident(targetColumn)
      || '::NUMERIC,' || minMaxRes.minimum || ',' || minMaxRes.maximum || ','
      || numBinsArr[i] || ') AS ew_binned_' || targetColumn;
    i = i + 1;
  END LOOP;

  EXECUTE format('DROP MATERIALIZED VIEW IF EXISTS %s', output_table);

  commandString := 'CREATE MATERIALIZED VIEW ' || output_table
    || ' AS ' || format('SELECT *%s FROM %s', binningString, source_table)
    || ' WITH DATA';
  RAISE NOTICE 'full cmd: %', commandString;
  EXECUTE commandString;

  RETURN 'Successfully created materialized view with entity name ' || output_table || '!';
  -- SELECT regexp_split_to_array('a,b,c,d', ',') INTO 

  -- EXECUTE format('CREATE TABLE IF NOT EXISTS %stest_flight AS
  -- SELECT * FROM flight', );

  -- -- get the minimum and maximum of the target_column to compute the binWidth
  -- EXECUTE format('SELECT MIN(%s::NUMERIC) as minimum, MAX(%s::NUMERIC) as maximum FROM %s', target_column, target_column, pg_typeof(source_table)) INTO minMaxRecord;

  -- -- iterate through the rows in source_table to append bin column and insert into output_table
  -- numRows := 0;
  -- FOR source_table IN EXECUTE
  --   format('SELECT * FROM %s', pg_typeof(source_table))
  -- LOOP
  --   numRows := numRows + 1;
  --   EXECUTE 'SELECT ($1.' || quote_ident(target_column) || '::NUMERIC)' USING source_table INTO currentContinuous;
  --   SELECT width_bucket(currentContinuous, minMaxRecord.minimum, minMaxRecord.maximum, num_bins) INTO currentBin;
  --   RAISE NOTICE 'minMaxRecord: % ; distance: % ; currentBin: %', minMaxRecord, currentContinuous, currentBin;
  --   EXECUTE format('INSERT INTO %s SELECT $1.*', output_table)
  --   USING source_table;
  -- END LOOP;
  -- RETURN 'Successfully binned ' || numRows || ' rows into ' || num_bins || ' bins!';
END;
$func$ LANGUAGE plpgsql;

SELECT bin_equal_width('flight', 'distance vism', 'test_flight', '10 9');

-- use this to veriy types, not working with dynamic sql for some reason
SELECT data_type FROM information_schema.columns WHERE table_name = 'flight' AND column_name = 'distance';

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

SELECT COUNT(*) from flight;

DROP FUNCTION bin_equal_width(text,text,text,text);
