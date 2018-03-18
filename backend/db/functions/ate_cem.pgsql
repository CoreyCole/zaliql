/**
Creates a table storing results from computer weighted average treatment effect
sourceTable must be the result of a `matchit_cem()` call
matchit_cem must have been performed with a binary treatment
grouping_attribute can be null
*/
CREATE OR REPLACE FUNCTION weighted_average_matchit_cem(
  source_table TEXT,
  output_table TEXT,
  treatment TEXT,
  outcome TEXT,
  grouping_attribute TEXT
) RETURNS TEXT AS $func$
DECLARE
  commandString TEXT;
  matchedDataSize INTEGER;
BEGIN
  -- get the size of the matched data
  commandString := 'SELECT count(*) FROM ' || quote_ident(source_table);
  EXECUTE commandString INTO matchedDataSize;

  -- reset commandString and build up returned query
  commandString := 'CREATE TABLE ' || quote_ident(output_table) || ' AS WITH Blocks AS ('
    || ' SELECT avg(' || quote_ident(outcome) || ') AS avg_outcome, subclass_id, '
    || quote_ident(treatment);

  IF grouping_attribute IS NOT NULL THEN
    commandString := commandString || ', ' || quote_ident(grouping_attribute);
  END IF;

  commandString := commandString || ' FROM ' || quote_ident(source_table)
    || ' GROUP BY subclass_id, ' || quote_ident(treatment);

  IF grouping_attribute IS NOT NULL THEN
    commandString := commandString || ', ' || quote_ident(grouping_attribute);
  END IF;

  commandString := commandString || '), Weights AS ('
    || ' SELECT cast(count(*) as NUMERIC) / ' || matchedDataSize::TEXT || ' as block_weight, subclass_id'
    || ' FROM ' || quote_ident(source_table) || ' GROUP BY subclass_id';

  IF grouping_attribute IS NOT NULL THEN
    commandString := commandString || ', ' || quote_ident(grouping_attribute);
  END IF;

  commandString := commandString || ' HAVING count(DISTINCT ' || quote_ident(treatment) || ') = 2)'
    || ' SELECT Blocks.' || quote_ident(treatment) || ' AS treatment,'
    || ' sum(avg_outcome * block_weight) AS weighted_avg_outcome';

  IF grouping_attribute IS NOT NULL THEN
    commandString := commandString || ', ' || quote_ident(grouping_attribute);
  END IF;

  commandString := commandString || ' FROM Blocks, Weights WHERE Blocks.subclass_id = Weights.subclass_id'
    || ' GROUP BY Blocks.' || quote_ident(treatment);

  IF grouping_attribute IS NOT NULL THEN
    commandString := commandString || ', ' || quote_ident(grouping_attribute);
  END IF;

  EXECUTE commandString;

  RETURN 'ATE successfull and output in table ' || quote_ident(output_table) || '!';

END;
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_json_ate(
  table_name TEXT,
  treatment TEXT,
  grouping_attribute TEXT
) RETURNS JSONB AS $func$
DECLARE
  command_string TEXT;
  result_arr JSONB;
BEGIN
  command_string := 'SELECT json_agg(json_build_object('
    || '''' || treatment || ''', treatment, '
    || '''weighted_avg_outcome'', weighted_avg_outcome';

  IF grouping_attribute IS NOT NULL THEN
    command_string := command_string || ', ''' || grouping_attribute || ''', ' || quote_ident(grouping_attribute);
  END IF;

  command_string := command_string || ')) FROM ' || quote_ident(table_name);

  EXECUTE command_string INTO result_arr;

  RETURN result_arr;
END;
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ate_cem(
  source_table TEXT,            -- input table name that was input into matchit_cem
  matchit_table TEXT,           -- input table name that was output by matchit_cem
  treatment TEXT,               -- column name of the treatment of interest
  outcome TEXT,                 -- column name of the outcome of interest
  grouping_attribute TEXT,      -- compare ATE across specified groups (can be null)
  ordinal_covariates_arr TEXT[] -- array of original ordinal covariate column names
                                --  (column names BEFORE discretization/binning)
                                --  can be empty array or null if no covariates were ordinal
) RETURNS JSONB AS $func$
DECLARE
  output_table TEXT;
  drop_output_command TEXT;
  covariate TEXT;
  call_status TEXT;
  return_string TEXT;
  result_arr JSONB;
  result JSONB;
BEGIN
  output_table := source_table || '_ate_cem';
  PERFORM weighted_average_matchit_cem(source_table, output_table, treatment, outcome, grouping_attribute);

  SELECT get_json_ate(output_table, treatment, grouping_attribute) INTO result_arr;

  result := jsonb_build_object(
    'treatment', result_arr
  );
  
  -- clean up result table
  drop_output_command := 'DROP TABLE ' || quote_ident(output_table);
  EXECUTE drop_output_command;

  IF ordinal_covariates_arr IS NOT NULL THEN
    FOREACH covariate IN ARRAY ordinal_covariates_arr LOOP
      PERFORM weighted_average_matchit_cem(source_table, output_table, treatment, outcome, grouping_attribute);
      SELECT get_json_ate(output_table, covariate, grouping_attribute) INTO result_arr;
      result := result || jsonb_build_object(
        covariate, result_arr
      );

      -- clean up result table
      EXECUTE drop_output_command; -- uses same output_table for treatment and all covariates
    END LOOP;
  END IF;

  RETURN result;
END;
$func$ LANGUAGE plpgsql;
