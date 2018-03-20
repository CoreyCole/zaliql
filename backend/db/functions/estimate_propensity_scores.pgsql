CREATE OR REPLACE FUNCTION estimate_propensity_scores(
  source_table TEXT,         -- input table name
  primary_key TEXT,          -- input table primary key
  treatment TEXT,            -- treatment column name
  covariates_text_arr TEXT,  -- expression list to evaluate for the independent variables
  output_table TEXT          -- output table name
) RETURNS TEXT AS $func$
DECLARE
  logregr_table TEXT;
  coef NUMERIC[];
  coef_text TEXT;
  command_string TEXT;
BEGIN
  -- Train logistic regression
  logregr_table := output_table || '_logregr';
  PERFORM madlib.logregr_train(
    source_table,
    logregr_table,
    treatment,
    covariates_text_arr
  );

  -- Get logistic regression coefficients
  command_string := 'SELECT coef FROM ' || quote_ident(logregr_table);
  EXECUTE command_string INTO coef;
  SELECT array_to_string(coef, ',') INTO coef_text;

  -- Create table
  command_string := 'CREATE TABLE ' || quote_ident(output_table)
    || ' AS (SELECT ' || quote_ident(source_table) || '.' || quote_ident(primary_key)
    || ' AS ' || quote_ident(primary_key) || ','
    || ' madlib.logregr_predict_prob(ARRAY[' || coef_text || '], '
    || covariates_text_arr || ') AS logregr_predict_prob, 0 AS used FROM ' || quote_ident(source_table) || ')';
  EXECUTE command_string;

  RETURN 'Propensity score estimations successfully output in table ' || output_table || '!';
END;
$func$ LANGUAGE plpgsql;
