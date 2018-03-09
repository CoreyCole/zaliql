CREATE OR REPLACE FUNCTION multi_treatment_matchit(
  sourceTable TEXT,             -- input table name
  primaryKey TEXT,              -- source table's primary key
  treatmentsArr TEXT[],         -- array of treatment column names
  covariatesArraysArr TEXT[][], -- array of arrays of covariates, each treatment has its own set of covariates
  outputTableBasename TEXT      -- name used in all output tables, treatment appended
) RETURNS TEXT AS $func$
DECLARE
  commandString TEXT;
  resultString TEXT;
  resultStringTemp TEXT;
  treatment TEXT;
  index INTEGER;
  covariateArr TEXT[];
  allCovariates TEXT[];
  covariate TEXT;
BEGIN

  allCovariates = ARRAY[]::TEXT[];
  FOREACH covariateArr SLICE 1 IN ARRAY covariatesArraysArr LOOP
    allCovariates = array_cat(allCovariates, covariateArr);
  END LOOP;
  allCovariates = array_distinct(allCovariates); -- gets unique covariates

  commandString = 'DROP MATERIALIZED VIEW IF EXISTS ' || outputTableBasename;
  EXECUTE commandString;

  -- create new mat view with column T that is the T1 | T2 | T3 | ... | TN
  -- union of all covariates arr (dynamic build up query to UNION all)
  -- D' <- matchit_cem(sourceTableMatViewWithT, T, CovUnion)
  -- D1' <- matchit_cem(D', T, CovUnion)
  -- D2' <- matchit_cem(D', T, CovUnion)

  SELECT matchit_cem(
    sourceTable,
    primaryKey,
    treatmentsArr,
    allCovariates,
    outputTableBasename
  ) INTO resultString;
  
  index = 0;
  FOREACH treatment IN ARRAY treatmentsArr LOOP
    SELECT ARRAY(SELECT unnest(treatmentsArr[index:1])) INTO covariateArr;
    index = index + 1;

    commandString = 'DROP MATERIALIZED VIEW IF EXISTS ' || outputTableBasename || '_' || treatment;
    EXECUTE commandString;

    SELECT matchit_cem(
      sourceTable,
      primaryKey,
      array_append(ARRAY[]::TEXT[], treatment),
      covariateArr,
      outputTableBasename || '_' || treatment
    ) INTO resultStringTemp;

    -- combine result strings
    resultString = resultString || ' ' || resultStringTemp;
  END LOOP;

  RETURN resultString;
END;
$func$ LANGUAGE plpgsql;
