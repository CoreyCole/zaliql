-- compute weighted average treatment effect for each covariate

-- average difference of the means before and after matching = imbalance reduction
--  fraction of improvement = 100 * (avg_diff_beofre - avg_diff_after) / avg_diff_before
-- ignore balance improvement
-- ignore red vs green

-- qq plot quantile function percentile_cont(0.1), percentile_cont(0.2) ...
-- for both before and after matching, for each covariate
-- use bubble combo line chart on frontend
CREATE OR REPLACE FUNCTION get_json_covariate_stats(
  sourceTable TEXT,
  treatment TEXT,
  covariatesArr TEXT[]
) RETURNS JSONB AS $func$
DECLARE
  commandString TEXT;
  jsonCommandString TEXT;
  covariate TEXT;
  meanTreatedAvg NUMERIC;
  meanTreatedStdDev NUMERIC;
  meanControlAvg NUMERIC;
  meanControlStdDev NUMERIC;
  jsonResult JSONB;
BEGIN
  jsonCommandString = 'SELECT jsonb_build_object(';
  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString = 'SELECT avg(' || covariate ||')'
      || ' FROM ' || sourceTable
      || ' WHERE ' || treatment || ' = 1;';
    EXECUTE commandString INTO meanTreatedAvg;
    commandString = 'SELECT stddev_pop(' || covariate ||')'
      || ' FROM ' || sourceTable
      || ' WHERE ' || treatment || ' = 1;';
    EXECUTE commandString INTO meanTreatedStdDev;
    commandString = 'SELECT avg(' || covariate ||')'
      || ' FROM ' || sourceTable
      || ' WHERE ' || treatment || ' = 0;';
    EXECUTE commandString INTO meanControlAvg;
    commandString = 'SELECT stddev_pop(' || covariate ||')'
      || ' FROM ' || sourceTable
      || ' WHERE ' || treatment || ' = 0;';
    EXECUTE commandString INTO meanControlStdDev;
    jsonCommandString = jsonCommandString || '''' || covariate || ''', '
      || 'jsonb_build_object('
        || '''meanTreated'', ' || meanTreatedAvg || ', '
        || '''meanTreatedStdDev'', ' || meanTreatedStdDev || ', '
        || '''meanControl'', ' || meanControlAvg || ', '
        || '''meanControlStdDev'', ' || meanControlStdDev || ', '
        || '''meanDiff'', ' || meanTreatedAvg - meanControlAvg
      || '), ';
  END LOOP;

  -- use substring here to chop off last comma
  jsonCommandString = substring( jsonCommandString from 0 for (char_length(jsonCommandString) - 1) );

  jsonCommandString = jsonCommandString || ');';

  RAISE NOTICE '%', jsonCommandString;
  EXECUTE jsonCommandString INTO jsonResult;
  RETURN jsonResult;
END;
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION stat_summary_cem(
  original_table TEXT,          -- original input table name
  matchit_cem_table TEXT,       -- table name that was output by matchit
  treatment TEXT,               -- column name of the treatment of interest
  outcome TEXT,                 -- column name of the outcome of interest
  grouping_attribute TEXT,      -- compare ATE across specified groups (can be null)
  covariates_arr TEXT[]         -- array of all original covariate column names
                                --  (column names AFTER discretization/binning)
  ordinal_covariates_arr TEXT[] -- array of original ordinal covariate column names
                                --  (column names BEFORE discretization/binning)
) RETURNS JSONB AS $func$
DECLARE
  all_json JSONB;
  matched_json JSONB;
  ate_json JSONB;
  qq_json JSONB;
BEGIN
  SELECT get_json_covariate_stats(original_table, treatment, covariates_arr)
    INTO all_json;
  SELECT get_json_covariate_stats(matchit_cem_table, treatment, covariates_arr)
    INTO matched_json;
  SELECT ate_cem(original_table, matchit_cem_table, treatment, outcome, grouping_attribute, ordinal_covariates_arr)
    INTO ate_json;
  SELECT qq_cem(original_table, matchit_cem_table, ordinal_covariates_arr)
    INTO qq_json;
  RETURN jsonb_build_object(
    'allData', all_json,
    'matchedData', matched_json
    'ate', ate_json,
    'qq', qq_json
  );
END;
$func$ LANGUAGE plpgsql;
