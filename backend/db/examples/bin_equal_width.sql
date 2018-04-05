DROP TABLE IF EXISTS flights_weather_demo_binned;

-- test `bin_equal_width()`
SELECT bin_equal_width(
  'flights_weather_demo',
  ARRAY['vism', 'wspdm'],
  ARRAY[10, 9],
  'flights_weather_demo_binned'
);

DROP TABLE flights_weather_demo_binned;
