CREATE OR REPLACE FUNCTION get_json_covariate_stats(
  sourceTable TEXT,
  treatment TEXT,
  covariatesArr TEXT[]
) RETURNS JSON AS $func$
DECLARE
  commandString TEXT;
  jsonCommandString TEXT;
  covariate TEXT;
  meanTreatedAvg NUMERIC;
  meanTreatedStdDev NUMERIC;
  meanControlAvg NUMERIC;
  meanControlStdDev NUMERIC;
  jsonResult JSON;
BEGIN
  jsonCommandString = 'SELECT json_build_object(';
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
      || 'json_build_object('
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

CREATE OR REPLACE FUNCTION matchit_summary(
  originalSourceTable TEXT,  -- original input table name
  matchedSourceTable TEXT,   -- table name that was output by matchit
  treatment TEXT,            -- treatment column name
  covariatesArr TEXT[]       -- array of covariate column names
) RETURNS JSON AS $func$
DECLARE
  allJson JSON;
  matchedJson JSON;
BEGIN
  SELECT get_json_covariate_stats(originalSourceTable, treatment, covariatesArr) INTO allJson;
  SELECT get_json_covariate_stats(matchedSourceTable, treatment, covariatesArr) INTO matchedJson;
  RETURN json_build_object(
    'allData', allJson,
    'matchedData', matchedJson
  );
END;
$func$ LANGUAGE plpgsql;
