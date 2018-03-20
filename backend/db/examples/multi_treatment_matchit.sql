-- test `array_distinct()`
SELECT array_distinct(array[1,2,3,21,1,2,1]);

DROP TABLE IF EXISTS test_flight_lowpressure_matched;
DROP TABLE IF EXISTS test_flight_rain_matched;
DROP TABLE IF EXISTS test_flight_all_treatments_matched;
DROP TABLE IF EXISTS test_flight_all_treatments;

-- test `multi_treatment_matchit()`
SELECT multi_treatment_matchit(
  'flights_weather_demo',
  'fid',
  ARRAY['lowpressure', 'rain'],
  ARRAY[
    ARRAY['fog', 'hail'],
    ARRAY['fog', 'hail']
  ],
  'test_flight'
);

-- see `matchit_cem()` results with treatment = lowpressure
SELECT * FROM test_flight_lowpressure_matched;

-- see `matchit_cem()` results with treatment = rain
SELECT * FROM test_flight_rain_matched;

-- see intermediate table with composite column 'matchit_t' that is the union of all treatments
SELECT * FROM test_flight_all_treatments;

-- see `matchit_cem()` results wih treatment = matchit_t
SELECT * FROM test_flight_all_treatments_matched;

DROP TABLE test_flight_lowpressure_matched;
DROP TABLE test_flight_rain_matched;
DROP TABLE test_flight_all_treatments_matched;
DROP TABLE test_flight_all_treatments;
