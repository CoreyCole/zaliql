CREATE OR REPLACE FUNCTION two_table_matchit(
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
  intermediate_table = output_table || '_intermediate';
  joined_table = output_table || '_joined';

  SELECT matchit_cem(
    source_table_a,
    source_table_a_primary_key,
    treatment,
    covariates_arr_a,
    intermediate_table
  ) INTO result_string;

  command_string = 'CREATE TABLE ' || joined_table
    || ' AS SELECT * FROM ' || intermediate_table
    || ' JOIN ' || source_table_b || ' ON '
    || source_table_b || '.' || source_table_b_primary_key || ' = '
    || intermediate_table || '.' || source_table_a_foreign_key;
  EXECUTE command_string;

  RETURN matchit_cem(
    joined_table,
    source_table_b_primary_key,
    treatment,
    covariates_arr_b,
    output_table
  );
END;
$func$ LANGUAGE plpgsql;
