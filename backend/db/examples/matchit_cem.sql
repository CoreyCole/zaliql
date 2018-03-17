DROP MATERIALIZED VIEW IF EXISTS test_flight;

SELECT matchit_cem('demo_data_1000000', 'fid', ARRAY['carrier', 'lowpressure'], ARRAY['rain', 'fog'], 'test_flight');

SELECT lowpressure, rain_matched, fog_matched, count(*), avg(depdelay)
	FROM test_flight GROUP BY lowpressure, rain_matched, fog_matched 
	ORDER BY lowpressure, rain_matched, fog_matched;

SELECT * FROM test_flight;

DROP FUNCTION matchit_cem(text,text,text[],text[],text);

SELECT matchit_cem(
  'demo_data_1000000',
  'fid',
  'lowpressure',
  ARRAY['rain', 'fog'],
  'test_flight'
); 

CREATE TABLE test_flight AS
WITH subclasses AS 
  (SELECT max(fid) AS subclass_id,
    rain AS rain_matched,
    fog AS fog_matched
  FROM demo_data_1000000
  GROUP BY  rain_matched, fog_matched
  HAVING count(DISTINCT lowpressure) = 2)
SELECT *
FROM subclasses, demo_data_1000000 st
WHERE subclasses.rain_matched = st.rain
  AND subclasses.fog_matched = st.fog
  AND lowpressure IS NOT NULL
