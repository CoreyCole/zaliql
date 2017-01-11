CREATE OR REPLACE FUNCTION bin_equal_frequency(
  source_table TEXT,  -- input table name
  target_column TEXT, -- input table column name
  output_table TEXT,  -- output table name
  frequency NUMERIC   -- ~number of values in each bin
) RETURNS TEXT AS $func$
BEGIN

END;
$func$ LANGUAGE plpgsql;
