DROP MATERIALIZED VIEW IF EXISTS test_flight;

SELECT multi_treatment_matchit('demo_test_1000', 'fid', ARRAY['thunder', 'rain'], ARRAY[ARRAY['fog', 'hail'], ARRAY['fog', 'hail']], 'test_flight');

SELECT * FROM test_flight;

DROP FUNCTION multi_treatment_matchit(text,text,text[],text[][],text);

CREATE OR REPLACE FUNCTION array_distinct(anyarray)
RETURNS anyarray AS $$
  SELECT ARRAY(SELECT DISTINCT unnest($1))
$$ LANGUAGE sql;

SELECT array_distinct(array[1,2,3,21,1,2,1]);
