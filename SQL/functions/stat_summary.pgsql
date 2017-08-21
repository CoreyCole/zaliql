SELECT stat_summary('demo_data_1000000', 'test_flight', 'lowpressure', ARRAY['thunder', 'snow', 'lowvisibility']);

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

CREATE OR REPLACE FUNCTION stat_summary(
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

/*
SELECT matchit('demo_test_1000000', 'fid', 'thunder', 'fog hail rain snow tornado', 'test_flight', '', '', '', false);

SELECT count(*), thunder, fog, hail, rain, snow, tornado FROM test_flight GROUP BY thunder, fog, hail, rain, snow, tornado ORDER BY fog, hail, rain, snow, tornado, thunder;

SELECT avg(depdelay::NUMERIC), count(*) FROM test_flight WHERE thunder::NUMERIC = 0;
SELECT avg(depdelay::NUMERIC), count(*) FROM test_flight WHERE thunder::NUMERIC = 1;

-- compute ATE of thunder on flight delay before matching covariates
--
-- 20.8827177098521391
--
SELECT treatedAvg - controlAvg AS ATE_before_matching FROM
	(SELECT avg(depdelay::NUMERIC) AS treatedAvg, count(*) AS treatedCount FROM test_flight WHERE thunder::NUMERIC = 1) AS treated,
	(SELECT avg(depdelay::NUMERIC) AS controlAvg, count(*) AS controlCount FROM test_flight WHERE thunder::NUMERIC = 0) AS control;

-- compute weighted ATE of thunder on flight delay matching boolean covariates fog, hail, rain, snow, and tornado
-- (for the stored procedure I will be looping through all groups to build up this query, here I am just doing 3 groups for both treated and control)
--
-- 21.21946177055459660356
--
SELECT ( ( treatedAvg1 * treatedCount1 ) + ( treatedAvg2 * treatedCount2 ) + ( treatedAvg3 * treatedCount3 ) ) / treatedCount - 
	   ( ( controlAvg1 * controlCount1 ) + ( controlAvg2 * controlCount2 ) + ( controlAvg3 * controlCount3 ) ) / controlCount AS ATE_after_matching, 
	   treatedCount1, treatedCount2, treatedCount3, controlCount1, controlCount2, controlCount3 FROM
	-- compute weighted average stats for treated groups
	(SELECT avg(depdelay::NUMERIC) AS treatedAvg1, count(*) AS treatedCount1 FROM test_flight
		WHERE thunder::NUMERIC = 1 AND fog::NUMERIC = 0 AND hail::NUMERIC = 0 AND rain::NUMERIC = 1 AND snow::NUMERIC = 0 AND tornado::NUMERIC = 0) as treated1,
	(SELECT avg(depdelay::NUMERIC) AS treatedAvg2, count(*) AS treatedCount2 FROM test_flight
		WHERE thunder::NUMERIC = 1 AND fog::NUMERIC = 0 AND hail::NUMERIC = 0 AND rain::NUMERIC = 0 AND snow::NUMERIC = 0 AND tornado::NUMERIC = 1) as treated2,
	(SELECT avg(depdelay::NUMERIC) AS treatedAvg3, count(*) AS treatedCount3 FROM test_flight
		WHERE thunder::NUMERIC = 1 AND fog::NUMERIC = 1 AND hail::NUMERIC = 0 AND rain::NUMERIC = 0 AND snow::NUMERIC = 0 AND tornado::NUMERIC = 0) as treated3,
	-- compute weighted average stats for control groups
	(SELECT avg(depdelay::NUMERIC) AS controlAvg1, count(*) AS controlCount1 FROM test_flight
		WHERE thunder::NUMERIC = 0 AND fog::NUMERIC = 0 AND hail::NUMERIC = 0 AND rain::NUMERIC = 1 AND snow::NUMERIC = 0 AND tornado::NUMERIC = 0) as control1,
	(SELECT avg(depdelay::NUMERIC) AS controlAvg2, count(*) AS controlCount2 FROM test_flight
		WHERE thunder::NUMERIC = 0 AND fog::NUMERIC = 0 AND hail::NUMERIC = 0 AND rain::NUMERIC = 0 AND snow::NUMERIC = 0 AND tornado::NUMERIC = 1) as control2,
	(SELECT avg(depdelay::NUMERIC) AS controlAvg3, count(*) AS controlCount3 FROM test_flight
		WHERE thunder::NUMERIC = 1 AND fog::NUMERIC = 1 AND hail::NUMERIC = 0 AND rain::NUMERIC = 0 AND snow::NUMERIC = 0 AND tornado::NUMERIC = 0) as control3,
	-- compute total counts of treated and control
	(SELECT count(*) AS treatedCount FROM test_flight WHERE thunder::NUMERIC = 1) as treated,
	(SELECT count(*) as controlCount FROM test_flight WHERE thunder::NUMERIC = 0) as control;
*/

/*
(SELECT * FROM (
	(SELECT *, (avg_treated - avg_untreated) AS mean_diff FROM
		(
			(SELECT avg(dewpti::NUMERIC) AS avg_treated, stddev_pop(dewpti::NUMERIC) AS stddev_treated FROM test_flight WHERE treated::NUMERIC = 1) AS dewpti_treated
			CROSS JOIN
			(SELECT avg(dewpti::NUMERIC) AS avg_untreated, stddev_pop(dewpti::NUMERIC) AS stddev_untreated FROM test_flight WHERE treated::NUMERIC = 0) AS dewpti_untreated
		) AS dewpti_stats
	)
) AS dewpti)
UNION ALL
(SELECT * FROM (
	(SELECT *, (avg_treated - avg_untreated) AS mean_diff FROM
		(
			(SELECT avg(wspdm::NUMERIC) AS avg_treated, stddev_pop(wspdm::NUMERIC) AS stddev_treated FROM test_flight WHERE treated::NUMERIC = 1) AS wspdm_treated
			CROSS JOIN
			(SELECT avg(wspdm::NUMERIC) AS avg_untreated, stddev_pop(wspdm::NUMERIC) AS stddev_untreated FROM test_flight WHERE treated::NUMERIC = 0) AS wspdm_untreated
		) AS wspdm_stats
	)
) AS wspdm);
*/