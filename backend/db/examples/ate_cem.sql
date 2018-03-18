DROP table test_flight;

SELECT matchit_cem(
  'demo_data_1000000',
  'fid',
  'lowpressure',
  ARRAY['rain', 'fog'],
  'test_flight'
);

-- see number of pruned rows
-- originally 1,000,000 rows
SELECT count(*) FROM test_flight;

SELECT weighted_average_matchit_cem(
  'test_flight',
  'lowpressure',
  'depdel15',
  'dest'
);

-- outputs query
WITH Blocks AS 
    (SELECT avg(depdel15) AS avg_outcome,
         subclass_id,
         lowpressure,
         dest
    FROM test_flight
    GROUP BY  subclass_id, lowpressure, dest), Weights AS 
    (SELECT cast(count(*) AS NUMERIC) / 273762 AS block_weight,
         subclass_id
    FROM test_flight
    GROUP BY  subclass_id, dest
    HAVING count(DISTINCT lowpressure) = 2)
SELECT min(Blocks.subclass_id),
         Blocks.lowpressure,
         sum(avg_outcome * block_weight) AS weighted_avg_outcome,
         dest
FROM Blocks, Weights
WHERE Blocks.subclass_id = Weights.subclass_id
GROUP BY  Blocks.lowpressure, dest;
