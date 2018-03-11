-- Create type minMax
CREATE TYPE minMax AS (minimum NUMERIC, maximum NUMERIC);
CREATE OR REPLACE FUNCTION bin_equal_width(
  source_table TEXT,    -- input table name
  target_columns TEXT,  -- space separated list of continuous column names to bin
  output_table TEXT,    -- output table name
  num_bins TEXT         -- space separated list of prescribed number of bins, correspond to target_columns
) RETURNS TEXT AS $func$
DECLARE
  targetColumnArr TEXT[];
  numBinsArr TEXT[];
  i INTEGER;
  targetColumn TEXT;
  columnType TEXT;
  binningString TEXT;
  commandString TEXT;
  minMaxString TEXT;
  minMaxRes minMax;
  minMaxRecordArr minMax[];
BEGIN
  SELECT regexp_split_to_array(target_columns, '\s+') INTO targetColumnArr;
  SELECT regexp_split_to_array(num_bins, '\s+') INTO numBinsArr;

  -- check type of target columns to make sure they are numeric, integer, etc
  -- see query below function definition

  -- FOREACH targetColumn IN ARRAY targetColumnArr LOOP
  --   commandString := 'SELECT data_type FROM information_schema.columns WHERE'
  --     || ' table_name = ' || quote_ident(source_table)
  --     || ' AND column_name = ' || quote_ident(targetColumn);
  --   EXECUTE commandString INTO columnType;
  --   RAISE NOTICE 'column type: %', columnType;
  -- END LOOP;

  -- check if output table exists, throw error?
  
  minMaxString := '';
  FOREACH targetColumn IN ARRAY targetColumnArr LOOP
    minMaxString = minMaxString || ', MIN(' || targetColumn || '::NUMERIC) as min_' || targetColumn || ','
      || ' MAX(' || targetColumn || '::NUMERIC) as max_' || targetColumn;
  END LOOP;

  -- use substring here to chop off the first comma in minMaxString (otherwise syntax error)
  commandString := 'SELECT ' || substring( minMaxString from 3 for ( char_length(minMaxString)) )
    || ' FROM ' || quote_ident(source_table);
  RAISE NOTICE 'full minMax cmd: %', commandString;
  
  EXECUTE format('CREATE TEMP TABLE minMaxRecord AS %s', commandString);

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

  commandString := 'CREATE TABLE ' || output_table
    || ' AS ' || format('SELECT *%s FROM %s', binningString, source_table);
  RAISE NOTICE '%', commandString;
  EXECUTE commandString;

  DROP TABLE minMaxRecord;
  RETURN 'Successfully created table ' || output_table || '!';
END;
$func$ LANGUAGE plpgsql;
