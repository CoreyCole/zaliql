CREATE OR REPLACE FUNCTION bin_quantile(
  source_table TEXT,    -- input table name
  target_column TEXT,   -- input table column name
  output_table TEXT,    -- output table name
  num_intervals NUMERIC -- number of intervals to split data into
) RETURNS TEXT AS $func$

$func$ LANGUAGE plpgsql;
