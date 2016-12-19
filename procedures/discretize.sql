CREATE OR REPLACE FUNCTION discretize(
  source_table TEXT,          -- input table name
  covariates TEXT,            -- comma-separated covariate column names
  bin_function TEXT,          -- name of desired binning function
  bin_function_input NUMERIC, -- value of binning function input
  output_table TEXT,          -- output table name
  width NUMERIC               -- width of each bin interval
) RETURNS TEXT AS $func$
BEGIN

END;
$func$ LANGUAGE plpgsql;
