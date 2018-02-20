DROP MATERIALIZED VIEW IF EXISTS test_flight;

SELECT matchit_cem('demo_data_1000000', 'fid', ARRAY['lowpressure'], ARRAY['rain', 'fog'], 'test_flight');

SELECT lowpressure, rain_matched, fog_matched, count(*), avg(depdelay)
	FROM test_flight GROUP BY lowpressure, rain_matched, fog_matched 
	ORDER BY lowpressure, rain_matched, fog_matched;

SELECT * FROM test_flight;

DROP FUNCTION matchit_cem(text,text,text[],text[],text);
