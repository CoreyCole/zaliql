/**
Creates a table storing results from computer weighted average treatment effect
source_table must be the result of a `matchit_cem()` call
matchit_cem must have been performed with a binary treatment
grouping_attribute can be null
RETURNS size of source_table
*/
CREATE OR REPLACE FUNCTION weighted_average_matchit_cem(
  source_table TEXT,
  output_table TEXT,
  treatment TEXT,
  outcome TEXT,
  grouping_attribute TEXT
) RETURNS TEXT AS $func$
DECLARE
  command_string TEXT;
  data_size INTEGER;
BEGIN
  -- get the size of the matched data
  command_string := 'SELECT count(*) FROM ' || quote_ident(source_table);
  EXECUTE command_string INTO data_size;

  -- reset command_string and build up returned query
  command_string := 'CREATE TABLE ' || quote_ident(output_table) || ' AS WITH Blocks AS ('
    || ' SELECT avg(' || quote_ident(outcome) || ') AS avg_outcome, subclass_id, '
    || quote_ident(treatment);

  IF grouping_attribute IS NOT NULL THEN
    command_string := command_string || ', ' || quote_ident(grouping_attribute);
  END IF;

  command_string := command_string || ' FROM ' || quote_ident(source_table)
    || ' GROUP BY subclass_id, ' || quote_ident(treatment);

  IF grouping_attribute IS NOT NULL THEN
    command_string := command_string || ', ' || quote_ident(grouping_attribute);
  END IF;

  command_string := command_string || '), Weights AS ('
    || ' SELECT cast(count(*) as NUMERIC) / ' || data_size::TEXT || ' as block_weight, subclass_id'
    || ' FROM ' || quote_ident(source_table) || ' GROUP BY subclass_id';

  IF grouping_attribute IS NOT NULL THEN
    command_string := command_string || ', ' || quote_ident(grouping_attribute);
  END IF;

  command_string := command_string || ')'
    || ' SELECT Blocks.' || quote_ident(treatment) || ' AS treatment,'
    || ' sum(avg_outcome * block_weight) AS weighted_avg_outcome';

  IF grouping_attribute IS NOT NULL THEN
    command_string := command_string || ', ' || quote_ident(grouping_attribute);
  END IF;

  command_string := command_string || ' FROM Blocks, Weights WHERE Blocks.subclass_id = Weights.subclass_id'
    || ' GROUP BY Blocks.' || quote_ident(treatment);

  IF grouping_attribute IS NOT NULL THEN
    command_string := command_string || ', ' || quote_ident(grouping_attribute);
  END IF;

  RAISE NOTICE '%', command_string;
  EXECUTE command_string;

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
    || '''treatment'', treatment, '
    || '''weighted_avg_outcome'', weighted_avg_outcome';

  IF grouping_attribute IS NOT NULL THEN
    command_string := command_string || ', ''grouping_attribute'', ' || quote_ident(grouping_attribute);
  END IF;

  command_string := command_string || ')) FROM ' || quote_ident(table_name);

  IF grouping_attribute IS NOT NULL THEN
    command_string := command_string || ' GROUP BY ' || quote_ident(grouping_attribute);
  END IF;

  RAISE NOTICE '%', command_string;
  EXECUTE command_string INTO result_arr;

  RETURN result_arr;
END;
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ate_cem(
  original_table TEXT,          -- input table name that was input into matchit_cem
  matchit_cem_table TEXT,       -- input table name that was output by matchit_cem
  treatment TEXT,               -- column name of the treatment of interest
  outcome TEXT,                 -- column name of the outcome of interest
  grouping_attribute TEXT,      -- compare ATE across specified groups (can be null)
  binned_covariates_arr TEXT[], -- array of original binned covariate column names
                                --  (column names AFTER discretization/binning)
                                --  can be empty array if no covariates were binned
  binary_covariates_arr TEXT[]  -- array of binary covariate column names
                                --  can be empty array if no covairates were binary
) RETURNS JSONB AS $func$
DECLARE
  output_table TEXT;
  drop_output_command TEXT;
  command_string TEXT;
  covariate TEXT;
  original_avg_outcome_treated NUMERIC;
  original_avg_outcome_control NUMERIC;
  orignal_avg_diff NUMERIC;
  matched_avg_diff NUMERIC;
  matched_treatment_result_arr JSONB;
  result_arr JSONB;
  original_treatment_result_arr JSONB;
  original_binary_covariates_result_arr JSONB;
  matched_binary_covariates_result_arr JSONB;
  binned_covariates_result_arr JSONB;
BEGIN
  output_table := matchit_cem_table || '_ate_cem';
  
  -- clean up result table
  drop_output_command := 'DROP TABLE ' || quote_ident(output_table);

  -- PERFORM weighted_average_matchit_cem(original_table, output_table, treatment, outcome, grouping_attribute);

  -- SELECT get_json_ate(output_table, treatment, grouping_attribute)
  --   INTO original_treatment_result_arr;

  -- EXECUTE drop_output_command;

  PERFORM weighted_average_matchit_cem(matchit_cem_table, output_table, treatment, outcome, grouping_attribute);

  SELECT get_json_ate(output_table, treatment, grouping_attribute)
    INTO matched_treatment_result_arr;

  EXECUTE drop_output_command;
  
  -- original_binary_covariates_result_arr := jsonb_build_object();
  -- IF binary_covariates_arr IS NOT NULL THEN
  --   FOREACH covariate IN ARRAY binary_covariates_arr LOOP
  --     PERFORM weighted_average_matchit_cem(original_table, output_table, covariate, outcome, grouping_attribute);
  --     SELECT get_json_ate(output_table, covariate, grouping_attribute)
  --       INTO result_arr;
  --     original_binary_covariates_result_arr := original_binary_covariates_result_arr || jsonb_build_object(
  --       covariate, result_arr
  --     );
  --     -- clean up result table
  --     EXECUTE drop_output_command; -- uses same output_table for treatment and all covariates 
  --   END LOOP;
  -- END IF;

  matched_binary_covariates_result_arr := jsonb_build_object();
  IF binary_covariates_arr IS NOT NULL THEN
    FOREACH covariate IN ARRAY binary_covariates_arr LOOP
      PERFORM weighted_average_matchit_cem(matchit_cem_table, output_table, covariate, outcome, grouping_attribute);
      SELECT get_json_ate(output_table, covariate, grouping_attribute)
        INTO result_arr;
      matched_binary_covariates_result_arr := matched_binary_covariates_result_arr || jsonb_build_object(
        covariate, result_arr
      );
      -- clean up result table
      EXECUTE drop_output_command; -- uses same output_table for treatment and all covariates 
    END LOOP;
  END IF;

  -- binned_covariates_result_arr := jsonb_build_object();
  -- IF binned_covariates_arr IS NOT NULL THEN
  --   FOREACH covariate IN ARRAY binned_covariates_arr LOOP
  --     PERFORM weighted_average_matchit_cem(matchit_cem_table, output_table, covariate, outcome, grouping_attribute);
  --     SELECT get_json_ate(output_table, covariate, grouping_attribute)
  --       INTO result_arr;
  --     binned_covariates_result_arr := binned_covariates_result_arr || jsonb_build_object(
  --       covariate, result_arr
  --     );
  --     -- clean up result table
  --     EXECUTE drop_output_command; -- uses same output_table for treatment and all covariates 
  --   END LOOP;
  -- END IF;

  -- get ate from unmatched data
  command_string := 'SELECT avg(' || quote_ident(outcome) || ')'
    || ' FROM ' || quote_ident(original_table)
    || ' WHERE ' || quote_ident(treatment) || ' = 1';
  EXECUTE command_string INTO original_avg_outcome_treated;
  command_string := 'SELECT avg(' || quote_ident(outcome) || ')'
    || ' FROM ' || quote_ident(original_table)
    || ' WHERE ' || quote_ident(treatment) || ' = 0';
  EXECUTE command_string INTO original_avg_outcome_control;
  orignal_avg_diff = original_avg_outcome_treated - original_avg_outcome_control;

  RETURN jsonb_build_object(
    'originalData', jsonb_build_object(
        'avgOutcomeTreated', original_avg_outcome_treated,
        'avgOutcomeControl', original_avg_outcome_control,
        'avgOutcomeDiff', orignal_avg_diff
      ),
    'matchedData', jsonb_build_object(
      'treatment', matched_treatment_result_arr,
      'binary_covariates', matched_binary_covariates_result_arr
    )
  );
END;
$func$ LANGUAGE plpgsql;

-- compute weighted average treatment effect for each covariate

-- average difference of the means before and after matching = imbalance reduction
--  fraction of improvement = 100 * (avg_diff_beofre - avg_diff_after) / avg_diff_before
-- ignore balance improvement
-- ignore red vs green

-- qq plot quantile function percentile_cont(0.1), percentile_cont(0.2) ...
-- for both before and after matching, for each covariate
-- use bubble combo line chart on frontend
CREATE OR REPLACE FUNCTION get_json_covariate_stats(
  source_table TEXT,
  treatment TEXT,
  covariates_arr TEXT[]
) RETURNS JSONB AS $func$
DECLARE
  command_string TEXT;
  json_command_string TEXT;
  covariate TEXT;
  mean_treated_avg NUMERIC;
  mean_treated_std_dev NUMERIC;
  mean_control_avg NUMERIC;
  mean_control_std_dev NUMERIC;
  json_result JSONB;
  total_data_size INTEGER;
  treated_data_size INTEGER;
  control_data_size INTEGER;
BEGIN
  IF covariates_arr IS NULL OR array_length(covariates_arr, 1) IS NULL THEN
    RETURN jsonb_build_object();
  END IF;

  json_command_string = 'SELECT jsonb_build_object(';
  FOREACH covariate IN ARRAY covariates_arr LOOP
    command_string := 'SELECT avg(' || quote_ident(covariate) || ')'
      || ' FROM ' || quote_ident(source_table)
      || ' WHERE ' || quote_ident(treatment) || ' = 1';
    EXECUTE command_string INTO mean_treated_avg;
    command_string := 'SELECT stddev_pop(' || quote_ident(covariate) || ')'
      || ' FROM ' || quote_ident(source_table)
      || ' WHERE ' || quote_ident(treatment) || ' = 1';
    EXECUTE command_string INTO mean_treated_std_dev;
    command_string := 'SELECT avg(' || quote_ident(covariate) || ')'
      || ' FROM ' || quote_ident(source_table)
      || ' WHERE ' || quote_ident(treatment) || ' = 0';
    EXECUTE command_string INTO mean_control_avg;
    command_string := 'SELECT stddev_pop(' || quote_ident(covariate) || ')'
      || ' FROM ' || quote_ident(source_table)
      || ' WHERE ' || quote_ident(treatment) || ' = 0';
    EXECUTE command_string INTO mean_control_std_dev;
    json_command_string := json_command_string || '''' || covariate || ''', '
      || 'jsonb_build_object('
        || '''meanTreated'', ' || mean_treated_avg || ', '
        || '''meanTreatedStdDev'', ' || mean_treated_std_dev || ', '
        || '''meanControl'', ' || mean_control_avg || ', '
        || '''meanControlStdDev'', ' || mean_control_std_dev || ', '
        || '''meanDiff'', ' || mean_treated_avg - mean_control_avg
      || '), ';
  END LOOP;

  -- use substring here to chop off last comma
  json_command_string = substring( json_command_string from 0 for (char_length(json_command_string) - 1) );

  json_command_string = json_command_string || ');';

  RAISE NOTICE '%', json_command_string;
  EXECUTE json_command_string INTO json_result;
  json_result := jsonb_build_object('covariateStats', json_result);

  -- get sample sizes
  command_string := 'SELECT count(*) FROM ' || quote_ident(source_table);
  EXECUTE command_string INTO total_data_size;
  command_string := 'SELECT count(*) FROM ' || quote_ident(source_table)
    || ' WHERE ' || quote_ident(treatment) || ' = 1';
  EXECUTE command_string INTO treated_data_size;
  command_string := 'SELECT count(*) FROM ' || quote_ident(source_table)
    || ' WHERE ' || quote_ident(treatment) || ' = 0';
  EXECUTE command_string INTO control_data_size;

  json_result := json_result || jsonb_build_object('dataSizes', jsonb_build_object(
    'totalDataSize', total_data_size,
    'treatedDataSize', treated_data_size,
    'controlDataSize', control_data_size
  ));

  RETURN json_result;
END;
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_qq(
  table_name TEXT,
  treatment TEXT,
  covariate TEXT
) RETURNS JSONB AS $func$
DECLARE
  quantile_arr NUMERIC[];
  quantile NUMERIC;
  treated_quantile_result NUMERIC;
  control_quantile_result NUMERIC;
  command_string TEXT;
  result JSONB;
BEGIN
  quantile_arr := '{0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9}';
  result := jsonb_build_object();
  FOREACH quantile IN ARRAY quantile_arr LOOP
    command_string := 'SELECT percentile_cont(' || quantile || ')'
      || ' WITHIN GROUP (ORDER BY ' || quote_ident(covariate) || ')'
      || ' FROM ' || quote_ident(table_name)
      || ' WHERE ' || quote_ident(treatment) || ' = 1';
    EXECUTE command_string INTO treated_quantile_result;
    command_string := 'SELECT percentile_cont(' || quantile || ')'
      || ' WITHIN GROUP (ORDER BY ' || quote_ident(covariate) || ')'
      || ' FROM ' || quote_ident(table_name)
      || ' WHERE ' || quote_ident(treatment) || ' = 0';
    EXECUTE command_string INTO control_quantile_result;
    result := result || jsonb_build_object(
      quantile,
      jsonb_build_object(
        'treated', treated_quantile_result,
        'control', control_quantile_result
      )
    );
  END LOOP;
  
  RETURN result;
END;
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION qq_cem(
  original_table TEXT,            -- original, unmatched source_table
  matchit_cem_table TEXT,         -- output table from `matchit_cem()`
  treatment TEXT,                 -- treatment column name
  original_covariates_arr TEXT[], -- array of all original covariate column names
                                  --  (column names BEFORE discretization/binning)
  binned_covariates_arr TEXT[]    -- array of all binned covariate column names
                                  --  (column names AFTER discretization/binning)
) RETURNS JSONB AS $func$
DECLARE
  covariate TEXT;
  covariate_idx INTEGER;
  original_qq JSONB;
  matched_qq JSONB;
  result JSONB;
BEGIN
  result := jsonb_build_object();

  covariate_idx := 1;
  FOREACH covariate IN ARRAY original_covariates_arr LOOP
    SELECT get_qq(original_table, treatment, covariate)
      INTO original_qq;
    SELECT get_qq(matchit_cem_table, treatment, binned_covariates_arr[covariate_idx])
      INTO matched_qq;
    result := result || jsonb_build_object(
      covariate, jsonb_build_object(
        'originalData', original_qq,
        'matchedData', matched_qq
      )
    );
    covariate_idx := covariate_idx + 1;
  END LOOP;

  RETURN result;
END;
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION matchit_cem_summary_statistics(
  binned_original_table TEXT, -- original input table name with binned columns
                              -- (table name after discretization/binning if binning was done
                              --  otherwise table name before binning is OK)
  matchit_cem_table TEXT,     -- table name that was output by matchit_cem
  treatment TEXT,             -- column name of the treatment of interest
  outcome TEXT,               -- column name of the outcome of interest
  grouping_attribute TEXT,    -- compare ATE across specified groups (can be null)
  original_covariates_arr TEXT[],         -- array of all original covariate column names
                                          --  (column names BEFORE discretization/binning)
  original_ordinal_covariates_arr TEXT[], -- array of original ordinal covariate column names
                                          --  (column names BEFORE discretization/binning)
                                          --  can be empty array if no covariates were ordinal
  binned_ordinal_covariates_arr TEXT[]    -- array of all binned ordinal covariate column names
                                          --  (column names AFTER discretization/binning)
                                          --  can be empty array if no covariates were ordinal
) RETURNS JSONB AS $func$
DECLARE
  all_json JSONB;
  matched_json JSONB;
  ate_json JSONB;
  qq_json JSONB;
  binary_covariates_arr TEXT[];
  pre_matched_covariates_arr TEXT[];
  matched_covariates_arr TEXT[];
BEGIN
  IF grouping_attribute='null' THEN
    grouping_attribute = NULL;
  END IF;

  SELECT array_agg(elements) FROM (
    SELECT unnest(original_covariates_arr)
    EXCEPT
    SELECT unnest(original_ordinal_covariates_arr)
  ) t (elements) INTO binary_covariates_arr;

  SELECT array_cat(binary_covariates_arr, original_ordinal_covariates_arr)
    INTO pre_matched_covariates_arr;

  SELECT array_cat(binary_covariates_arr, binned_ordinal_covariates_arr)
    INTO matched_covariates_arr;

  SELECT get_json_covariate_stats(binned_original_table, treatment, pre_matched_covariates_arr)
    INTO all_json;
  SELECT get_json_covariate_stats(matchit_cem_table, treatment, matched_covariates_arr)
    INTO matched_json;
  SELECT ate_cem(binned_original_table, matchit_cem_table, treatment, outcome, grouping_attribute, binned_ordinal_covariates_arr, binary_covariates_arr)
    INTO ate_json;
  SELECT qq_cem(binned_original_table, matchit_cem_table, treatment, original_ordinal_covariates_arr, binned_ordinal_covariates_arr)
    INTO qq_json;
  
  RETURN jsonb_build_object(
    'allData', all_json,
    'matchedData', matched_json,
    'ate', ate_json,
    'qq', qq_json
  );
END;
$func$ LANGUAGE plpgsql;
