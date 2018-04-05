DROP TABLE IF EXISTS test_flight;

-- test `two_table_matchit()`
SELECT two_table_matchit_cem(
  'flights_demo',
  'fid',
  'wid',
  ARRAY['dest'],
  'weather_demo',
  'wid',
  ARRAY['vism', 'hum', 'wspdm', 'thunder', 'fog', 'hail'],
  'carrierid',
  'test_flight'
);
