DROP TABLE IF EXISTS test_flight;
DROP TABLE IF EXISTS flights_weather_demo_binned;

-- bin ordinal column `vism` into 10 bins of equal width
SELECT bin_equal_width(
  'flights_weather_demo',
  ARRAY['vism'],
  ARRAY[10],
  'flights_weather_demo_binned'
);

-- perform `matchit_cem()` on the binned data
SELECT matchit_cem(
  'flights_weather_demo_binned',
  'fid',
  'lowpressure',
  ARRAY['vism_ew_binned_10', 'rain', 'fog'],
  'test_flight'
);

-- test `weighted_average_matchit_cem()`
SELECT weighted_average_matchit_cem(
  'test_flight',
  'test_flight_ate_cem',
  'lowpressure',
  'depdel15',
  'airport'
);

DROP TABLE test_flight_ate_cem;
-- `weighted_average_matchit_cem()` performs query to create table
-- 271297 is the size of the matched data
CREATE TABLE test_flight_ate_cem AS
WITH Blocks AS 
    (SELECT avg(depdel15) AS avg_outcome,
         subclass_id,
         lowpressure,
         airport
    FROM test_flight
    GROUP BY  subclass_id, lowpressure, airport), Weights AS 
    (SELECT cast(count(*) AS NUMERIC) / 271297 AS block_weight,
         subclass_id
    FROM test_flight
    GROUP BY  subclass_id, airport
    HAVING count(DISTINCT lowpressure) = 2)
SELECT Blocks.lowpressure AS treatment,
         sum(avg_outcome * block_weight) AS weighted_avg_outcome,
         airport
FROM Blocks, Weights
WHERE Blocks.subclass_id = Weights.subclass_id
GROUP BY  Blocks.lowpressure, airport;

-- test `get_json_ate()`
SELECT get_json_ate(
  'test_flight_ate_cem',
  'lowpressure',
  'airport'
);
DROP TABLE test_flight_ate_cem;

-- `weighted_average_matchit_cem()` & `get_json_ate()` are called internally
-- test `ate_cem()`
SELECT ate_cem(
  'flights_weather_demo',
  'test_flight',
  'lowpressure',
  'depdel15',
  'airport',
  ARRAY['vism']
);
-- should work with NULL grouping_attribute
SELECT ate_cem(
  'flights_weather_demo',
  'test_flight',
  'lowpressure',
  'depdel15',
  NULL,
  ARRAY['vism']
);
-- should work with empty ordinal_covariates_arr
SELECT ate_cem(
  'flights_weather_demo',
  'test_flight',
  'lowpressure',
  'depdel15',
  NULL,
  ARRAY[]::TEXT[]
);

-- test `get_qq()`
SELECT get_qq(
  'flights_weather_demo',
  'lowpressure',
  'vism'
);

-- test `qq_cem()`
SELECT qq_cem(
  'flights_weather_demo',
  'test_flight',
  'lowpressure',
  ARRAY['vism']
);

-- test `matchit_cem_summary_statistics()`
SELECT matchit_cem_summary_statistics(
  'flights_weather_demo_binned',
  'test_flight',
  'lowpressure',
  'depdel15',
  'dest',
  ARRAY['vism', 'wspdm', 'rain', 'fog'],
  ARRAY['vism', 'wspdm'],
  ARRAY['vism_ew_binned_10', 'wspdm_ew_binned_9']
);

DROP TABLE test_flight;
DROP TABLE flights_weather_demo_binned;
