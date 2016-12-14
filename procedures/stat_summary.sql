CREATE OR REPLACE FUNCTION stat_summary(
  source_table TEXT,  -- input table name
  verbose BOOLEAN,    -- (optional) print to std out
  target_cols TEXT,   -- comma-separated covariate column names
  output_table TEXT   -- output table name
) RETURNS TEXT AS $fun

$func$ LANGUAGE plpgsql;
