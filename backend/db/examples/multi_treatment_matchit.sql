DROP MATERIALIZED VIEW IF EXISTS test_flight;

SELECT multi_treatment_matchit('demo_test_1000', 'fid', ARRAY['thunder', 'rain'], ARRAY[ARRAY['fog', 'hail'], ARRAY['fog', 'hail']], 'test_flight');

SELECT * FROM test_flight;

DROP FUNCTION multi_treatment_matchit(text,text,text[],text[][],text);

CREATE OR REPLACE FUNCTION array_distinct(anyarray)
RETURNS anyarray AS $$
  SELECT ARRAY(SELECT DISTINCT unnest($1))
$$ LANGUAGE sql;

SELECT array_distinct(array[1,2,3,21,1,2,1]);

-- treatmens ['thunder', 'rain']
SELECT multi_treatment_matchit(
  'demo_test_1000',
  'fid',
  ARRAY['thunder', 'rain'],
  ARRAY[
    ARRAY['fog', 'hail'],
    ARRAY['fog', 'hail']
  ],
  'test_flight'
);

-- create D with all treatments combined using OR
-- combined treatments = `matchit_t`
CREATE MATERIALIZED VIEW test_flight_all_treatments AS 
  SELECT (thunder::BOOLEAN
    OR rain::BOOLEAN)::INTEGER
    AS matchit_t, *
FROM demo_test_1000
WITH DATA;

-- create D' with matchit_cem(D, T = matchit_t, uniqueCovariates)
CREATE MATERIALIZED VIEW test_flight_all_treatments_matched AS
WITH subclasses AS 
    (SELECT max(fid) AS subclass_fid,
         fog AS fog_matched,
         hail AS hail_matched
    FROM test_flight_all_treatments
    GROUP BY  fog_matched, hail_matched
    HAVING (count(DISTINCT matchit_t) = 2))
SELECT *
FROM subclasses, test_flight_all_treatments st
WHERE subclasses.fog_matched = st.fog
        AND subclasses.hail_matched = st.hail
        AND matchit_t IS NOT NULL
WITH DATA;

-- for each treatment, use D' and the treatment's respective covariates
-- for treatment = thunder
CREATE MATERIALIZED VIEW test_flight_thunder_matched AS
WITH subclasses AS 
    (SELECT max(subclass_fid) AS subclass_subclass_fid,
         thunder AS thunder_matched
    FROM test_flight_all_treatments_matched
    GROUP BY  thunder_matched
    HAVING (count(DISTINCT thunder) = 2))
SELECT *
FROM subclasses, test_flight_all_treatments_matched st
WHERE subclasses.thunder_matched = st.thunder
        AND thunder IS NOT NULL
WITH DATA;

-- for treatment = rain
CREATE MATERIALIZED VIEW test_flight_rain_matched AS
WITH subclasses AS 
    (SELECT max(subclass_fid) AS subclass_subclass_fid,
         thunder AS thunder_matched
    FROM test_flight_all_treatments_matched
    GROUP BY  thunder_matched
    HAVING (count(DISTINCT rain) = 2))
SELECT *
FROM subclasses, test_flight_all_treatments_matched st
WHERE subclasses.thunder_matched = st.thunder
        AND rain IS NOT NULL
WITH DATA;
