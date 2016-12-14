CREATE OR REPLACE FUNCTION matching_summary(
  source_table TEXT,  -- input table name
  covariates TEXT,    -- comma-separated covariate column names
  verbose BOOLEAN,    -- (optional) print to std out
  output_table TEXT  -- output table name
) RETURNS TEXT AS $func$

$func$ LANGUAGE plpgsql;
