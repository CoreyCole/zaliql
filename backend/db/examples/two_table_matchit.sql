DROP TABLE IF EXISTS test_flight;

-- test `two_table_matchit()`
SELECT two_table_matchit_cem(
  'flights_sfo',
  'fid',
  'wid',
  ARRAY['dest'],
  'weather_sfo',
  'wid',
  ARRAY['wspdm', 'vism', 'precipm', 'tempm', 'fog', 'highwindspeed'],
  'lowpressure',
  'flights_sfo_matched'
);
