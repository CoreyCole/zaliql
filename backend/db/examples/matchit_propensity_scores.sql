DROP TABLE lalonde_demo_logregr;
DROP TABLE lalonde_demo_logregr_summary;
DROP TABLE lalonde_demo_ps;
DROP TABLE lalonde_demo_matched;

SELECT matchit_propensity_score('lalonde_demo', 'pk', 'treat', ARRAY['age', 'educ', 'nodegree'], 2, 'lalonde_demo_matched');

SELECT * FROM lalonde_demo ORDER BY pk asc;
SELECT unnest(array['intercept', 'age', 'educ', 'nodegree']) as attribute,
       unnest(coef) as coefficient,
       unnest(std_err) as standard_error,
       unnest(z_stats) as z_stat,
       unnest(p_values) as pvalue,
       unnest(odds_ratios) as odds_ratio
FROM lalonde_demo_logregr;
SELECT * FROM lalonde_demo_logregr_summary;
SELECT * FROM lalonde_demo_ps;
SELECT * FROM lalonde_demo_matched;
SELECT treatment_pk, ld.id AS treatment_id, treatment_pp, control_pk, ld2.id AS control_id, control_pp
FROM lalonde_demo_matched ldm
JOIN lalonde_demo ld ON ld.pk = treatment_pk
JOIN lalonde_demo ld2 ON ld2.pk = control_pk;

DROP FUNCTION matchit_propensity_score(text,text,text[],text[],text);

/** Creating demo data with unique int primary keys */
DROP SEQUENCE lalonde_demo_id_seq;
CREATE SEQUENCE lalonde_demo_id_seq;
SELECT * FROM lalonde;
DROP TABLE lalonde_demo;
CREATE TABLE lalonde_demo (pk serial primary key, id TEXT, treat INTEGER, age INTEGER, educ INTEGER, black INTEGER, hispan INTEGER, married INTEGER, nodegree INTEGER, re74 NUMERIC, re75 NUMERIC, re78 NUMERIC);
SELECT * FROM lalonde_demo;
INSERT INTO lalonde_demo 
SELECT nextval('lalonde_demo_id_seq'), id, treat::INTEGER, age::INTEGER, educ::INTEGER, black::INTEGER, hispan::INTEGER, married::INTEGER, nodegree::INTEGER, re74::NUMERIC, re75::NUMERIC, re78::NUMERIC
FROM lalonde
ORDER BY id asc;
