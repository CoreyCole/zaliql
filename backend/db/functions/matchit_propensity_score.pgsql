CREATE OR REPLACE FUNCTION matchit_propensity_score(
  source_table TEXT,     -- input table name
  primary_key TEXT,      -- source table's primary key
  treatment TEXT,        -- treatment column name
  covariates_arr TEXT[], -- array of covariate column names (all covariates are applied to all treatments)
  k INTEGER,             -- k nearest neighbors
  caliper NUMERIC,       -- maximum (inclusive) propensity score distance to be considered a match
  output_table TEXT      -- output table name
) RETURNS TEXT AS $func$
DECLARE
  covariates_text_arr TEXT;
  kInt INTEGER;
  ps_output_table TEXT;
  idx INTEGER;
  treatment_row REFCURSOR;
  control_row REFCURSOR;
  min_tpp NUMERIC;
  curr_tpk INTEGER;      -- assumes integer primary key
  curr_tpp NUMERIC;
  curr_cpk INTEGER;
  curr_cpp NUMERIC;
  command_string TEXT;
BEGIN
  -- need to add "1" to front of array for intercept variable
  SELECT 'ARRAY[1,' || array_to_string(covariates_arr, ',') || ']' INTO covariates_text_arr;
  
  -- created matched output table
  command_string := 'CREATE TABLE ' || output_table
    || ' (treatment_pk INTEGER, treatment_pp NUMERIC, control_pk INTEGER, control_pp NUMERIC)';
  EXECUTE command_string;

  -- create propensity score output table
  ps_output_table := source_table || '_' || output_table || '_ps';
  PERFORM estimate_propensity_scores(
    source_table,
    primary_key,
    treatment,
    covariates_text_arr,
    ps_output_table
  ); -- outputs { pk, propensity_score } tuples to output table

  -- get the minimum treatment propensity score (logregr_predict_prob from logistic regression)
  command_string := 'SELECT min(logregr_predict_prob) FROM ' || ps_output_table
    || ' JOIN ' || quote_ident(source_table) || ' ON ' || ps_output_table || '.' || quote_ident(primary_key) || ' = ' || quote_ident(source_table) || '.' || quote_ident(primary_key)
    || ' WHERE ' || quote_ident(source_table) || '.' || quote_ident(treatment) || ' = 1';
  EXECUTE command_string INTO min_tpp;

  -- query to point cursor to treatment rows sorted in ascending order by propensity score
  command_string := 'SELECT ' || ps_output_table || '.' || quote_ident(primary_key) || ',' || ps_output_table || '.logregr_predict_prob FROM ' || ps_output_table
    || ' JOIN ' || quote_ident(source_table) || ' ON ' || ps_output_table || '.' || quote_ident(primary_key) || ' = ' || quote_ident(source_table) || '.' || quote_ident(primary_key)
    || ' WHERE ' || ps_output_table || '.logregr_predict_prob IS NOT NULL'
    || ' AND ' || quote_ident(source_table) || '.' || quote_ident(treatment) || ' = 1' -- get treated subjects
    || ' ORDER BY ' || ps_output_table || '.logregr_predict_prob';
  OPEN treatment_row FOR EXECUTE command_string;

  /**
   * query to point cursor to control rows sorted in ascending order by
   *   abs( controlPropensityScore - minTreatmentPropensityScore )
   */
  command_string := 'SELECT ' || ps_output_table || '.' || quote_ident(primary_key) || ',' || ps_output_table || '.logregr_predict_prob FROM ' || ps_output_table
    || ' JOIN ' || quote_ident(source_table) || ' ON ' || ps_output_table || '.' || quote_ident(primary_key) || ' = ' || quote_ident(source_table) || '.' || quote_ident(primary_key)
    || ' WHERE ' || ps_output_table || '.logregr_predict_prob IS NOT NULL'
    || ' AND ' || quote_ident(source_table) || '.' || quote_ident(treatment) || ' = 0' -- get control subjects
    || ' ORDER BY abs(' || ps_output_table || '.logregr_predict_prob - ' || min_tpp::TEXT || ')';
  idx := 0;
  OPEN control_row FOR EXECUTE command_string;

  WHILE TRUE LOOP
    IF (idx % k) = 0 THEN --TODO: add caliper skip to next treatment if out of range of caliper
      FETCH treatment_row INTO curr_tpk, curr_tpp;
    END IF;
    FETCH control_row INTO curr_cpk, curr_cpp;
    IF curr_tpk IS NULL OR curr_cpk IS NULL THEN
      EXIT; -- exits loop if out of treatments or controls
    END IF;
    command_string := 'INSERT INTO ' || output_table || ' (treatment_pk, control_pk, treatment_pp, control_pp) VALUES'
      || ' (' || curr_tpk || ',' || curr_cpk || ',' || curr_tpp || ',' || curr_cpp || ')';
    EXECUTE command_string;
    
    idx := idx + 1;
  END LOOP;

  RETURN 'Propensity score matching successful and output in table ' || output_table || '!';
END;
$func$ LANGUAGE plpgsql;
