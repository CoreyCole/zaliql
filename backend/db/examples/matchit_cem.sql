DROP TABLE IF EXISTS test_flight;

-- test `matchit_cem()`
SELECT matchit_cem(
  'flights_weather_demo',
  'fid',
  'lowpressure',
  ARRAY['hour', 'rain', 'fog'],
  'test_flight'
);
-- should perform query
CREATE TABLE test_flight AS
WITH subclasses AS 
    (SELECT max(fid) AS subclass_id,
         hour AS hour_matched,
         rain AS rain_matched,
         fog AS fog_matched
    FROM flights_weather_demo
    GROUP BY  hour_matched, rain_matched, fog_matched
    HAVING count(DISTINCT lowpressure) = 2)
SELECT *
FROM subclasses, flights_weather_demo st
WHERE subclasses.hour_matched = st.hour
        AND subclasses.rain_matched = st.rain
        AND subclasses.fog_matched = st.fog
        AND lowpressure IS NOT NULL 
SELECT lowpressure, rain_matched, fog_matched, count(*), avg(depdelay)
	FROM test_flight GROUP BY lowpressure, rain_matched, fog_matched 
	ORDER BY lowpressure, rain_matched, fog_matched;
