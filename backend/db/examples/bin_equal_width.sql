DROP TABLE IF EXISTS flights_weather_demo_binned;

-- test `bin_equal_width()`
SELECT bin_equal_width(
  'flights_weather_sfo',
  ARRAY['wspdm', 'vism', 'precipm', 'tempm'],
  ARRAY[10, 15, 15, 20],
  'flights_weather_sfo_binned'
);

DROP TABLE flights_weather_demo_binned;
