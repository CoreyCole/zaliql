SELECT ate('test_flight', 'depdelay', 'lowpressure', ARRAY['thunder_matched', 'snow_matched', 'lowvisibility_matched']);

DROP MATERIALIZED VIEW IF EXISTS test_flight;

SELECT matchit('demo_data_1000000', 'fid', ARRAY['lowpressure'], ARRAY['thunder', 'snow', 'lowvisibility'], 'test_flight');

SELECT 
  lowpressure AS treatment,
  thunder_matched AS cov1,
  snow_matched AS cov2,
  lowvisibility_matched AS cov3,
  count(*) AS groupSize,
  avg(depdelay) AS avgOutcome
FROM test_flight
WHERE treatment IS NOT NULL
GROUP BY treatment, cov1, cov2, cov3
ORDER BY cov1, cov2, cov3, treatment;
