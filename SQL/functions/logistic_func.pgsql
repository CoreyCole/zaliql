CREATE OR REPLACE FUNCTION logistic_func(
  theta NUMERIC,
  x NUMERIC,
) RETURNS NUMERIC AS $func$
BEGIN
  RETURN 1.0 / (1 + exp(1) ^ )
END;
$func$ LANGUAGE plpgsql;
