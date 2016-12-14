CREATE OR REPLACE FUNCTION bin_equal_width(
  source_table TEXT,  -- input table name
  target_column TEXT, -- input table column name
  output_table TEXT,  -- output table name
  width NUMERIC       -- width of each bin interval
) RETURNS TEXT AS $func$

$func$ LANGUAGE plpgsql;
