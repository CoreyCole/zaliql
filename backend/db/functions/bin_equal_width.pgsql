-- Create type minMax
CREATE TYPE minMax AS (minimum NUMERIC, maximum NUMERIC);
CREATE OR REPLACE FUNCTION bin_equal_width(
  source_table TEXT,    -- input table name
  target_columns TEXT,  -- space separated list of continuous column names to bin
  output_table TEXT,    -- output table name
  num_bins TEXT         -- space separated list of prescribed number of bins, correspond to target_columns
) RETURNS TEXT AS $func$
DECLARE
  target_column_arr TEXT[];
  num_bins_arr TEXT[];
  i INTEGER;
  target_column TEXT;
  column_type TEXT;
  binning_string TEXT;
  command_string TEXT;
  min_max_string TEXT;
  min_max_res minMax;
BEGIN
  SELECT regexp_split_to_array(target_columns, '\s+') INTO target_column_arr;
  SELECT regexp_split_to_array(num_bins, '\s+') INTO num_bins_arr;

  -- check type of target columns to make sure they are numeric, integer, etc
  -- see query below function definition

  -- FOREACH target_column IN ARRAY target_column_arr LOOP
  --   command_string := 'SELECT data_type FROM information_schema.columns WHERE'
  --     || ' table_name = ' || quote_ident(source_table)
  --     || ' AND column_name = ' || quote_ident(target_column);
  --   EXECUTE command_string INTO column_type;
  --   RAISE NOTICE 'column type: %', column_type;
  -- END LOOP;

  -- check if output table exists, throw error?
  
  min_max_string := '';
  FOREACH target_column IN ARRAY target_column_arr LOOP
    min_max_string = min_max_string || ', MIN(' || target_column || '::NUMERIC) as min_' || target_column || ','
      || ' MAX(' || target_column || '::NUMERIC) as max_' || target_column;
  END LOOP;

  -- use substring here to chop off the first comma in min_max_string (otherwise syntax error)
  command_string := 'SELECT ' || substring( min_max_string from 3 for ( char_length(min_max_string)) )
    || ' FROM ' || quote_ident(source_table);
  RAISE NOTICE 'full minMax cmd: %', command_string;
  
  EXECUTE format('CREATE TEMP TABLE minMaxRecord AS %s', command_string);

  binning_string := '';
  i := 1;
  FOREACH target_column IN ARRAY target_column_arr LOOP
    EXECUTE format('SELECT min_%s as minimum, max_%s as maximum FROM minMaxRecord', target_column, target_column) INTO min_max_res;
    RAISE NOTICE 'min:% max:%', min_max_res.minimum, min_max_res.maximum;
    binning_string = binning_string || ', width_bucket(' || quote_ident(target_column)
      || '::NUMERIC,' || min_max_res.minimum || ',' || min_max_res.maximum || ','
      || numBinsArr[i] || ') AS ew_binned_' || target_column;
    i = i + 1;
  END LOOP;

  command_string := 'CREATE TABLE ' || output_table
    || ' AS ' || format('SELECT *%s FROM %s', binning_string, source_table);
  RAISE NOTICE '%', command_string;
  EXECUTE command_string;

  DROP TABLE minMaxRecord;
  RETURN 'Successfully created table ' || output_table || '!';
END;
$func$ LANGUAGE plpgsql;
