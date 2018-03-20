DROP TABLE IF EXISTS test_flight;

-- test `bin_equal_width()`
SELECT bin_equal_width(
  'flights_weather_demo',
  ARRAY['pressurem', 'vism'],
  ARRAY[10, 9],
  'test_flight'
);

DROP TABLE test_flight;
