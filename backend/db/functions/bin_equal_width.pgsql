-- Create type minMax
CREATE TYPE minMax AS (minimum NUMERIC, maximum NUMERIC);
CREATE OR REPLACE FUNCTION bin_equal_width(
  source_table TEXT,          -- input table name
  target_columns_arr TEXT[],  -- array of ordinal column names to bin
  num_bins_arr INTEGER[],     -- array of prescribed number of bins, correspond to target_columns
  output_table TEXT           -- output table name
) RETURNS TEXT AS $func$
DECLARE
  column_idx INTEGER;
  target_column TEXT;
  binning_string TEXT;
  command_string TEXT;
  min_max_string TEXT;
  min_max_res minMax;
BEGIN
  min_max_string := '';
  FOREACH target_column IN ARRAY target_columns_arr LOOP
    min_max_string := min_max_string || ', MIN(' || target_column || '::NUMERIC) as min_' || target_column || ','
      || ' MAX(' || target_column || '::NUMERIC) as max_' || target_column;
  END LOOP;

  -- use substring here to chop off the first comma in min_max_string (otherwise syntax error)
  command_string := 'SELECT ' || substring( min_max_string from 3 for ( char_length(min_max_string)) )
    || ' FROM ' || quote_ident(source_table);
  RAISE NOTICE 'full minMax cmd: %', command_string;
  
  EXECUTE format('CREATE TEMP TABLE minMaxRecord AS %s', command_string);

  binning_string := '';
  column_idx := 1;
  FOREACH target_column IN ARRAY target_columns_arr LOOP
    RAISE NOTICE '%', binning_string;
    EXECUTE format('SELECT min_%s as minimum, max_%s as maximum FROM minMaxRecord', target_column, target_column) INTO min_max_res;
    RAISE NOTICE 'min:% max:%', min_max_res.minimum, min_max_res.maximum;
    RAISE NOTICE '% : % : ', num_bins_arr[column_idx]::TEXT, target_column || '_ew_binned_' || num_bins_arr[column_idx]::TEXT;
    binning_string := binning_string || ', width_bucket(' || quote_ident(target_column) || ', ' 
      || min_max_res.minimum || ', ' || min_max_res.maximum || ', '
      || num_bins_arr[column_idx]::TEXT || ') AS ' || target_column || '_ew_binned_' || num_bins_arr[column_idx]::TEXT;
    column_idx = column_idx + 1;
  END LOOP;
  RAISE NOTICE '%', binning_string;
  command_string := 'CREATE TABLE ' || output_table
    || ' AS ' || format('SELECT *%s FROM %s', binning_string, source_table);
  RAISE NOTICE '%', command_string;
  EXECUTE command_string;

  DROP TABLE minMaxRecord;
  RETURN 'Successfully created binned table ' || output_table || '!';
END;
$func$ LANGUAGE plpgsql;
