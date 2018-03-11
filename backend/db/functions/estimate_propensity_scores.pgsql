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

  -- Create table
  commandString := 'CREATE TABLE ' || outputTable
    || ' AS (SELECT ' || sourceTable || '.' || primaryKey || ' AS ' || primaryKey || ','
    || ' madlib.logregr_predict_prob(ARRAY[' || coefText || '], '
    || covariatesTextArr || ') AS logregr_predict_prob, 0 AS used FROM ' || sourceTable || ')';
  EXECUTE commandString;

  RETURN 'Propensity score estimations successfully output in table ' || outputTable || '!';
END;
$func$ LANGUAGE plpgsql;
