DROP TABLE IF EXISTS flights_weather_demo_test_flight_ps;
DROP TABLE IF EXISTS flights_weather_demo_test_flight_ps_logregr;
DROP TABLE IF EXISTS flights_weather_demo_test_flight_ps_logregr_summary;
DROP TABLE IF EXISTS test_flight;

-- test `matchit_propensity_score()`
SELECT matchit_propensity_score(
  'flights_weather_sfo',
  'fid',
  'lowpressure',
  ARRAY['vism', 'hum', 'wspdm', 'thunder', 'fog', 'hail'],
  2,
  0.1,
  'test_flight'
);

-- see all propensity score matches
SELECT * FROM test_flight;

-- see logistic regression model
SELECT unnest(array['intercept', 'hour', 'fog', 'hail']) as attribute,
       unnest(coef) as coefficient,
       unnest(std_err) as standard_error,
       unnest(z_stats) as z_stat,
       unnest(p_values) as pvalue,
       unnest(odds_ratios) as odds_ratio
FROM flights_weather_sfo_test_flight_ps_logregr;

-- see summary of logistic regression training
SELECT * FROM flights_weather_sfo_test_flight_ps_logregr_summary;
