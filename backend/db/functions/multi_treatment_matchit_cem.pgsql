CREATE OR REPLACE FUNCTION array_distinct(anyarray)
RETURNS anyarray AS $$
  SELECT ARRAY(SELECT DISTINCT unnest($1))
$$ LANGUAGE sql;

-- PRECONDITION: Only supports binary treatment columns
CREATE OR REPLACE FUNCTION multi_treatment_matchit_cem(
  source_table TEXT,              -- input table name
  primary_key TEXT,               -- source table's primary key
  treatments_arr TEXT[],          -- array of treatment column names
  covariates_arrays_arr TEXT[][], -- array of arrays of covariates, each treatment has its own set of covariates
  output_table_basename TEXT      -- name used in all output tables, treatment appended
) RETURNS TEXT AS $func$
DECLARE
  command_string TEXT;
  all_treatments_name TEXT;
  all_treatments_matched_name TEXT;
  result_string TEXT;
  result_string_temp TEXT;
  treatment TEXT;
  treatment_idx INTEGER;
  covariate_arr TEXT[];
  unique_covariates TEXT[];
  covariate TEXT;
  matched_pk TEXT;
BEGIN
  -- get unique covariates
  unique_covariates = ARRAY[]::TEXT[];
  -- plpgsql arrays indexed at 1
  FOREACH covariate_arr SLICE 1 IN ARRAY covariates_arrays_arr LOOP
    unique_covariates = array_cat(unique_covariates, covariate_arr);
  END LOOP;
  unique_covariates = array_distinct(unique_covariates);
  RAISE NOTICE 'Unique covariates: %', unique_covariates;

  -- create new table with column `matchit_t` that is the T_1 OR T_2 OR ... OR T_N
  all_treatments_name := output_table_basename || '_all_treatments';
  command_string := 'CREATE TABLE ' || all_treatments_name || ' AS SELECT (';
  FOREACH treatment IN ARRAY treatments_arr LOOP
    command_string := command_string || treatment || '::BOOLEAN OR ';
  END LOOP;

  -- use substring here to chop off last OR
  command_string := substring( command_string from 0 for (char_length(command_string) - 3) );

  -- name combined treatment variable `matchit_t, SELECT rest of columns`
  command_string := command_string || ')::INTEGER AS matchit_t, * FROM ' || source_table;

  -- create the OR combined treatment table
  RAISE NOTICE '%', command_string;
  EXECUTE command_string;

  -- call matchit on the combined treatment variable
  -- to prune subjects that don't satisfy the overlap condition
  all_treatments_matched_name := all_treatments_name || '_matched';
  SELECT matchit_cem(
    all_treatments_name,
    primary_key,
    'matchit_t',
    unique_covariates,
    all_treatments_matched_name
  ) INTO result_string;

  -- drop the subclass_id column because this will be created again in subsequent calls
  command_string := 'ALTER TABLE ' || quote_ident(all_treatments_matched_name)
    || ' DROP COLUMN subclass_id';
  EXECUTE command_string;

  -- drop the matched covariate columns as they will be created again in subsequent calls
  FOREACH covariate IN ARRAY unique_covariates LOOP
    command_string := 'ALTER TABLE ' || quote_ident(all_treatments_matched_name)
      || ' DROP COLUMN ' || quote_ident(covariate || '_matched');
    EXECUTE command_string;
  END LOOP;
  
  treatment_idx := 1;
  FOREACH treatment IN ARRAY treatments_arr LOOP
    SELECT ARRAY(SELECT unnest(covariates_arrays_arr[treatment_idx:treatment_idx])) INTO covariate_arr;
    treatment_idx := treatment_idx + 1;

    SELECT matchit_cem(
      all_treatments_matched_name,
      primary_key,
      treatment,
      covariate_arr,
      output_table_basename || '_' || treatment || '_matched'
    ) INTO result_string_temp;

    -- combine result strings
    result_string := result_string || ' ' || result_string_temp;
  END LOOP;

  RETURN result_string;
END;
$func$ LANGUAGE plpgsql;
