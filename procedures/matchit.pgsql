CREATE OR REPLACE FUNCTION discretize(
  source_table TEXT,  -- input table name
  treatment TEXT,     -- treatment column name
  covariates TEXT,    -- comma-separated covariate column names
  output_table TEXT,  -- output table name
  method TEXT,        -- matching method, default "nearest"
  method_input TEXT,  -- (optional) matching method args
  discard TEXT,       -- discard units outside distance measure, default "none"
  reestimate BOOLEAN, -- reestimate distance measure after discarding units
) RETURNS TEXT AS $func$
BEGIN

END;
$func$ LANGUAGE plpgsql;
