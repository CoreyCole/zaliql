CREATE OR REPLACE FUNCTION two_table_matchit_cem(
  source_table_a TEXT,             -- input table A name
  source_table_a_primary_key TEXT, -- input table A primary key
  source_table_a_foreign_key TEXT, -- foreign key linking to input table B
  covariates_arr_a TEXT[],         -- covariates included in input table A
  source_table_b TEXT,             -- input table B name
  source_table_b_primary_key TEXT, -- input table B primary key
  covariates_arr_b TEXT[],         -- covariates included in input table B
  treatment TEXT,                  -- treatment column must be in source_table_a
  output_table TEXT                -- output table name
) RETURNS TEXT AS $func$
DECLARE
  intermediate_table TEXT;
  joined_table TEXT;
  result_string TEXT;
  command_string TEXT;
BEGIN
  intermediate_table := output_table || '_intermediate';
  joined_table := output_table || '_joined';

  SELECT matchit_cem(
    source_table_a,
    source_table_a_primary_key,
    treatment,
    covariates_arr_a,
    intermediate_table
  ) INTO result_string;

  -- need to remove subclass_id from intermediate_table so there are not duplicates after the
  -- second matchit_cem call
  command_string := 'ALTER TABLE ' || intermediate_table || ' DROP subclass_id';
  EXECUTE command_string;

  command_string := 'CREATE TABLE ' || joined_table
    || ' AS SELECT * FROM ' || intermediate_table
    || ' JOIN ' || source_table_b;
    
  IF source_table_a_foreign_key = source_table_b_primary_key THEN
    command_string := command_string || ' USING ('
      || source_table_b_primary_key || ')';
  ELSE
    command_string := command_string || ' ON '
      || source_table_b || '.' || source_table_b_primary_key || ' = '
      || intermediate_table || '.' || source_table_a_foreign_key;
  END IF;
    
  EXECUTE command_string;

  RETURN matchit_cem(
    joined_table,
    source_table_a_primary_key,
    treatment,
    covariates_arr_b,
    output_table
  );
END;
$func$ LANGUAGE plpgsql;
