DROP MATERIALIZED VIEW IF EXISTS test_flight;

SELECT multi_level_treatment_matchit('demo_test_1000', 'fid', 'thunder', 2, ARRAY['fog', 'hail'], 'test_flight');

SELECT * FROM test_flight;

DROP FUNCTION multi_level_treatment_matchit(text,text,text,integer,text[],text);

SELECT column_name FROM information_schema.columns WHERE table_name = 'demo_test_1000';


CREATE MATERIALIZED VIEW test_flight AS
WITH subclasses AS 
    (SELECT max(fid) AS subclass_fid,
         fog AS fog_matched,
         hail AS hail_matched
    FROM demo_test_1000
    GROUP BY  fog_matched, hail_matched
    HAVING count(distinct thunder) = 2)
SELECT *
FROM subclasses, demo_test_1000 st
WHERE subclasses.fog_matched = st.fog
        AND subclasses.hail_matched = st.hail
WITH DATA; 