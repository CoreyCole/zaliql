DROP TABLE test_flight_logregr;
DROP TABLE IF EXISTS test_flight_logregr_summary;
DROP TABLE IF EXISTS test_flight;

-- test `madlib.logregr_train()`
SELECT madlib.logregr_train(
  'flights_weather_sfo',                                       -- source table
  'test_logregr',                                              -- output table
  'depdel15',                                                  -- labels
  'ARRAY[1, wspdm, vism, precipm, tempm, fog, highwindspeed]'  -- covariates
);

-- test `estimate_propensity_scores()`
DROP TABLE test_flight_logregr;
DROP TABLE test_flight_logregr_summary;
SELECT estimate_propensity_scores(
  'flights_weather_sfo',
  'fid',
  'depdel15',
  'ARRAY[1, wspdm, vism, precipm, tempm, fog, highwindspeed]',
  'test_pp_output'
);

-- see all results of the logistic regression
SELECT unnest(array['intercept', 'fog', 'hail', 'thunder', 'lowvisibility', 'highwindspeed']) as attribute,
       unnest(coef) as coefficient,
       unnest(std_err) as standard_error,
       unnest(z_stats) as z_stat,
       unnest(p_values) as pvalue,
       unnest(odds_ratios) as odds_ratio
FROM test_flight_logregr;

-- see just logistic regression coefficients
SELECT coef FROM flights_weather_demo_logregr;

-- see logistic regression prediction for each fid
SELECT
    flights_weather_demo.fid, 
    madlib.logregr_predict_prob(
      ARRAY[-1.90290678046899209,6.04963391099593622e-12,0,-0.662042576992547871,0,-10.2999800561562278],
      ARRAY[1, fog, hail, thunder, lowvisibility, highwindspeed]
    ) AS logregr_prob_prediction
FROM flights_weather_demo;

DROP TABLE flights_weather_demo_logregr;
DROP TABLE flights_weather_demo_logregr_summary;
DROP TABLE test_flight;
