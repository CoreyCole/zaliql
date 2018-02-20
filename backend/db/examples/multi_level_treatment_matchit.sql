DROP MATERIALIZED VIEW IF EXISTS test_flight;

SELECT multi_level_treatment_matchit('demo_test_1000', 'fid', 'thunder', 2, ARRAY['fog', 'hail'], 'test_flight');

SELECT * FROM test_flight;

DROP FUNCTION multi_level_treatment_matchit(text,text,text,integer,text[],text);

SELECT column_name FROM information_schema.columns WHERE table_name = 'demo_test_1000';
