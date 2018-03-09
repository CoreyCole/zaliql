CREATE OR REPLACE FUNCTION matchit_propensity_score(
  sourceTable TEXT,     -- input table name
  primaryKey TEXT,      -- source table's primary key
  treatment TEXT,       -- treatment column name
  covariatesArr TEXT[], -- array of covariate column names (all covariates are applied to all treatments)
  k INTEGER,            -- k nearest neighbors
  outputTable TEXT      -- output table name
) RETURNS TEXT AS $func$
DECLARE
  covariatesTextArr TEXT;
  kInt INTEGER;
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
    treatment,
    covariatesTextArr,
    psOutputTable
  ); -- outputs { pk, propensity_score } tuples to output table

  -- get the minimum treatment propensity score (logregr_predict_prob from logistic regression)
  commandString := 'SELECT min(logregr_predict_prob) FROM ' || psOutputTable
    || ' JOIN ' || sourceTable || ' ON ' || psOutputTable || '.' || primaryKey || ' = ' || sourceTable || '.' || primaryKey
    || ' WHERE ' || sourceTable || '.' || treatment || ' = 1';
  EXECUTE commandString INTO minTpp;

  /**
   * query to point cursor to treatment rows sorted in ascending order by propensity score
   */
  commandString := 'SELECT ' || psOutputTable || '.' || primaryKey || ',' || psOutputTable || '.logregr_predict_prob FROM ' || psOutputTable
    || ' JOIN ' || sourceTable || ' ON ' || psOutputTable || '.' || primaryKey || ' = ' || sourceTable || '.' || primaryKey
    || ' WHERE ' || psOutputTable || '.logregr_predict_prob IS NOT NULL'
    || ' AND ' || sourceTable || '.' || treatment || ' = 1' -- get treated subjects
    || ' ORDER BY ' || psOutputTable || '.logregr_predict_prob';
  OPEN treatmentRow FOR EXECUTE commandString;

  /**
   * query to point cursor to control rows sorted in ascending order by
   *   abs( controlPropensityScore - minTreatmentPropensityScore )
   */
  commandString := 'SELECT ' || psOutputTable || '.' || primaryKey || ',' || psOutputTable || '.logregr_predict_prob FROM ' || psOutputTable
    || ' JOIN ' || sourceTable || ' ON ' || psOutputTable || '.' || primaryKey || ' = ' || sourceTable || '.' || primaryKey
    || ' WHERE ' || psOutputTable || '.logregr_predict_prob IS NOT NULL'
    || ' AND ' || sourceTable || '.' || treatment || ' = 0' -- get control subjects
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
