CREATE OR REPLACE FUNCTION matchit_cem(
  source_table TEXT,     -- input table name
  primary_key TEXT,      -- source table's primary key
  treatment TEXT,       -- array of treatment column names
  covariates_arr TEXT[], -- array of covariate column names (all covariates are applied to all treatments)
  output_table TEXT      -- output table name
) RETURNS TEXT AS $func$
DECLARE
  command_string TEXT;
  treatment_levels INTEGER;
  covariate TEXT;
BEGIN
  -- compute the distinct levels of the given treatment variable
  -- SELECT count(distinct carrier), count(distinct lowpressure) from source_table
  command_string := 'SELECT count(DISTINCT ' || quote_ident(treatment) || ')::INTEGER FROM ' 
    || quote_ident(source_table);
  EXECUTE command_string INTO treatment_levels;

  command_string := 'WITH subclasses as (SELECT '
    || ' max(' || quote_ident(primary_key) || ') AS subclass_id';

  FOREACH covariate IN ARRAY covariates_arr LOOP
    command_string := command_string || ', ' || quote_ident(covariate) || ' AS ' 
      || quote_ident(covariate || '_matched');
  END LOOP;

  command_string := command_string || ' FROM ' || quote_ident(source_table) || ' GROUP BY ';

  FOREACH covariate IN ARRAY covariates_arr LOOP
    command_string := command_string || quote_ident(covariate || '_matched') || ', ';
  END LOOP;

  -- use substring here to chop off last comma
  command_string := substring( command_string from 0 for (char_length(command_string) - 1) );
  
  command_string := command_string || ' HAVING count(DISTINCT ' || quote_ident(treatment) || ') = '
    || treatment_levels::TEXT;

  command_string := command_string || ') SELECT * FROM subclasses, ' || quote_ident(source_table) || ' st WHERE';

  FOREACH covariate IN ARRAY covariates_arr LOOP
    command_string := command_string || ' subclasses.' || quote_ident(covariate || '_matched')
      || ' = st.' || quote_ident(covariate) || ' AND';
  END LOOP;

  command_string := command_string || ' ' || quote_ident(treatment) || ' IS NOT NULL';

  -- EXECUTE format('DROP MATERIALIZED VIEW IF EXISTS %s', output_table);

  command_string := 'CREATE TABLE ' || quote_ident(output_table)
    || ' AS ' || command_string;
  RAISE NOTICE '%', command_string;
  EXECUTE command_string;

  RETURN 'Coarsened exact matching successful and output in table ' || quote_ident(output_table) || '!';
END;
$func$ LANGUAGE plpgsql;
