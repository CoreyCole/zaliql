CREATE OR REPLACE FUNCTION matchit_propensity_score(
  sourceTable TEXT,     -- input table name
  primaryKey TEXT,      -- source table's primary key
  treatmentsArr TEXT[], -- array of treatment column names
  covariatesArr TEXT[], -- array of covariate column names (all covariates are applied to all treatments)
  k INTEGER,            -- k nearest neighbors
  outputTable TEXT      -- output table name
) RETURNS TEXT AS $func$
DECLARE
  treatmentText TEXT;   -- assumes only 1 treatment
  covariatesTextArr TEXT;
  psOutputTable TEXT;
  idx INTEGER;
  treatmentRow REFCURSOR;
  controlRow REFCURSOR;
  minTpp NUMERIC;
  currTpk INTEGER;      -- assumes integer primary key?
  currTpp NUMERIC;
  currCpk INTEGER;
  currCpp NUMERIC;
  commandString TEXT;
BEGIN
  -- assumes only 1 treatment
  SELECT array_to_string(treatmentsArr, ',')
    INTO treatmentText;
  -- need to add "1" to front of array for intercept variable
  SELECT 'ARRAY[1,' || array_to_string(covariatesArr, ',') || ']'
    INTO covariatesTextArr;
  
  -- created matched output table
  commandString := 'CREATE TABLE ' || outputTable
    || ' (treatment_pk INTEGER, treatment_pp NUMERIC, control_pk INTEGER, control_pp NUMERIC)';
  EXECUTE commandString;

  -- create propensity score output table
  psOutputTable := sourceTable || '_ps';
  PERFORM estimate_propensity_scores(
    sourceTable,
    primaryKey,
    treatmentText,
    covariatesTextArr,
    psOutputTable
  ); -- outputs { fid, propensity_score } tuples to output table

  -- get the minimum treatment propensity score (logregr_predict_prob from logistic regression)
  commandString := 'SELECT min(logregr_predict_prob) FROM ' || psOutputTable
    || ' JOIN ' || sourceTable || ' ON ' || psOutputTable || '.' || primaryKey || ' = ' || sourceTable || '.' || primaryKey
    || ' WHERE ' || sourceTable || '.' || treatmentText || ' = 1';
  EXECUTE commandString INTO minTpp;

  /**
   * query to point cursor to treatment rows sorted in ascending order by propensity score
   */
  commandString := 'SELECT ' || psOutputTable || '.' || primaryKey || ',' || psOutputTable || '.logregr_predict_prob FROM ' || psOutputTable
    || ' JOIN ' || sourceTable || ' ON ' || psOutputTable || '.' || primaryKey || ' = ' || sourceTable || '.' || primaryKey
    || ' WHERE ' || psOutputTable || '.logregr_predict_prob IS NOT NULL'
    || ' AND ' || sourceTable || '.' || treatmentText || ' = 1' -- get treated subjects
    || ' ORDER BY ' || psOutputTable || '.logregr_predict_prob';
  OPEN treatmentRow FOR EXECUTE commandString;

  /**
   * query to point cursor to control rows sorted in ascending order by
   *   abs( controlPropensityScore - minTreatmentPropensityScore )
   */
  commandString := 'SELECT ' || psOutputTable || '.' || primaryKey || ',' || psOutputTable || '.logregr_predict_prob FROM ' || psOutputTable
    || ' JOIN ' || sourceTable || ' ON ' || psOutputTable || '.' || primaryKey || ' = ' || sourceTable || '.' || primaryKey
    || ' WHERE ' || psOutputTable || '.logregr_predict_prob IS NOT NULL'
    || ' AND ' || sourceTable || '.' || treatmentText || ' = 0' -- get control subjects
    || ' ORDER BY abs(' || psOutputTable || '.logregr_predict_prob - ' || minTpp::TEXT || ')';
  idx := 0;
  OPEN controlRow FOR EXECUTE commandString;

  WHILE TRUE LOOP
    IF (idx % k) = 0 THEN
      FETCH treatmentRow INTO currTpk, currTpp;
    END IF;
    FETCH controlRow INTO currCpk, currCpp;
    IF currTpk IS NULL OR currCpk IS NULL THEN
      EXIT; -- exits loop if out of treatments or controls
    END IF;
    commandString := 'INSERT INTO ' || outputTable || ' (treatment_pk, control_pk, treatment_pp, control_pp) VALUES'
      || ' (' || currTpk || ',' || currCpk || ',' || currTpp || ',' || currCpp || ')';
    EXECUTE commandString;
    
    idx := idx + 1;
  END LOOP;
  /**
  nested for loop cursors
  - partition table into treated and control
    - keep control sorted ordered by propensity score
    - keep treated sorted as well
  - take
  */

  RETURN 'Propensity score matching successful and materialized in ' || outputTable || '!';
END;
$func$ LANGUAGE plpgsql;

DROP TABLE lalonde_demo_logregr;
DROP TABLE lalonde_demo_logregr_summary;
DROP MATERIALIZED VIEW IF EXISTS lalonde_demo_ps;
DROP TABLE lalonde_demo_matched;

SELECT matchit_propensity_score('lalonde_demo', 'pk', ARRAY['treat'], ARRAY['age', 'educ', 'nodegree'], 2, 'lalonde_demo_matched');

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
