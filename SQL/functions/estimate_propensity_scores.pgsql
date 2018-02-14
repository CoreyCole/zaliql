CREATE OR REPLACE FUNCTION estimate_propensity_scores(
  sourceTable TEXT,         -- input table name
  primaryKey TEXT,          -- input table primary key
  treatment TEXT,           -- treatment column name
  covariatesTextArr TEXT,   -- Expression list to evaluate for the independent variables
  outputTable TEXT          -- output table name
) RETURNS TEXT AS $func$
DECLARE
  logregrTable TEXT;
  coef NUMERIC[];
  coefText TEXT;
  commandString TEXT;
BEGIN
  -- Train logistic regression
  logregrTable := sourceTable || '_logregr';
  PERFORM madlib.logregr_train(
    sourceTable,
    logregrTable,
    treatment,
    covariatesTextArr
  );

  -- Get logistic regression coefficients
  commandString := 'SELECT coef FROM ' || logregrTable;
  EXECUTE commandString INTO coef;
  SELECT array_to_string(coef, ',') INTO coefText;

  -- Create materialzied view
  commandString := 'CREATE MATERIALIZED VIEW ' || outputTable
    || ' AS (SELECT ' || sourceTable || '.' || primaryKey || ' AS pk,'
    || ' madlib.logregr_predict_prob(ARRAY[' || coefText || '], '
    || covariatesTextArr || ') AS propensity_score, 0 AS used FROM ' || sourceTable || ') WITH DATA;';
  EXECUTE commandString;

  RETURN 'Propensity score estimations successfully materialized in ' || outputTable || '!';
END;
$func$ LANGUAGE plpgsql;

DROP TABLE demo_data_1000_logregr;
DROP TABLE demo_data_1000_logregr_summary;
DROP MATERIALIZED VIEW IF EXISTS test_flight;

SELECT estimate_propensity_scores('demo_data_1000', 'fid', 'depdel15', 'ARRAY[1, fog, hail, thunder, lowvisibility, highwindspeed]', 'test_flight');

SELECT * FROM test_flight;

DROP FUNCTION estimate_propensity_scores(text, text, text, text, text);

-- Example without function
DROP TABLE demo_data_1000_logregr;
DROP TABLE demo_data_1000_logregr_summary;
SELECT madlib.logregr_train(
  'demo_data_1000',                                 -- source table
  'demo_data_1000_logregr',                         -- output table
  'depdel15',                            -- labels
  'ARRAY[1, fog, hail, thunder, lowvisibility, highwindspeed]'
);
SELECT coef FROM demo_data_1000_logregr;
SELECT
    demo_data_1000.fid, 
    madlib.logregr_predict_prob(
      ARRAY[-1.90290678046899209,6.04963391099593622e-12,0,-0.662042576992547871,0,-10.2999800561562278],
      ARRAY[1, fog, hail, thunder, lowvisibility, highwindspeed]
    ) AS logregr_prob_prediction
FROM demo_data_1000;
