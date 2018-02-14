CREATE OR REPLACE FUNCTION matchit(
  sourceTable TEXT,     -- input table name
  primaryKey TEXT,      -- source table's primary key
  treatmentsArr TEXT[], -- array of treatment column names
  covariatesArr TEXT[], -- array covariate column names (all covariates are applied to all treatments)
  method TEXT,          -- matching method (either cem or ps for Propensity Score)
  outputTable TEXT      -- output table name
) RETURNS TEXT AS $func$
BEGIN
  CASE METHOD
    WHEN 'cem' THEN
      RETURN matchit_cem(
        sourceTable,
        primaryKey,
        treatmentsArr,
        covariatesArr,
        method,
        outputTable
      );
    WHEN 'ps' THEN
      RETURN matchit_propensity_score(
        sourceTable,
        primaryKey,
        treatmentsArr,
        covariatesArr,
        method,
        outputTable
      );
END;
$func$ LANGUAGE plpgsql;

DROP MATERIALIZED VIEW IF EXISTS test_flight;

SELECT matchit('demo_data_1000000', 'fid', ARRAY['lowpressure'], ARRAY['rain', 'fog'], 'cem', 'test_flight');
SELECT matchit('demo_data_1000000', 'fid', ARRAY['lowpressure'], ARRAY['rain', 'fog'], 'ps', 'test_flight');

SELECT lowpressure, rain_matched, fog_matched, count(*), avg(depdelay)
	FROM test_flight GROUP BY lowpressure, rain_matched, fog_matched 
	ORDER BY lowpressure, rain_matched, fog_matched;

SELECT * FROM test_flight;

DROP FUNCTION matchit(text,text,text[],text[],text,text);
