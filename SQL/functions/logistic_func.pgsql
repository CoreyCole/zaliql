CREATE OR REPLACE FUNCTION logistic_func(
  theta NUMERIC,        -- input table name
  x NUMERIC,            -- comma-separated covariate column names
) RETURNS NUMERIC AS $func$
BEGIN
  RETURN 1.0 / (1 + exp(1) ^ )
END;
$func$ LANGUAGE plpgsql;
