CREATE OR REPLACE FUNCTION array_distinct(anyarray)
RETURNS anyarray AS $$
  SELECT ARRAY(SELECT DISTINCT unnest($1))
$$ LANGUAGE sql;

-- PRECONDITION: Only supports binary treatment columns
CREATE OR REPLACE FUNCTION multi_treatment_matchit(
  sourceTable TEXT,             -- input table name
  primaryKey TEXT,              -- source table's primary key
  treatmentsArr TEXT[],         -- array of treatment column names
  covariatesArraysArr TEXT[][], -- array of arrays of covariates, each treatment has its own set of covariates
  outputTableBasename TEXT      -- name used in all output tables, treatment appended
) RETURNS TEXT AS $func$
DECLARE
  commandString TEXT;
  allTreatmentsName TEXT;
  allTreatmentsMatchedName TEXT;
  resultString TEXT;
  resultStringTemp TEXT;
  treatment TEXT;
  treatmentIndex INTEGER;
  covariateArr TEXT[];
  uniqueCovariates TEXT[];
  covariate TEXT;
  matchedPk TEXT;
BEGIN
  -- get unique covariates
  uniqueCovariates = ARRAY[]::TEXT[];
  FOREACH covariateArr SLICE 1 IN ARRAY covariatesArraysArr LOOP
    uniqueCovariates = array_cat(uniqueCovariates, covariateArr);
  END LOOP;
  uniqueCovariates = array_distinct(uniqueCovariates);
  RAISE NOTICE 'Unique covariates: %', uniqueCovariates;

  -- create new table with column `matchit_t` that is the T_1 OR T_2 OR ... OR T_N
  allTreatmentsName := outputTableBasename || '_all_treatments';
  commandString := 'CREATE TABLE ' || allTreatmentsName || ' AS SELECT (';
  FOREACH treatment IN ARRAY treatmentsArr LOOP
    commandString := commandString || treatment || '::BOOLEAN OR ';
  END LOOP;

  -- use substring here to chop off last OR
  commandString := substring( commandString from 0 for (char_length(commandString) - 3) );

  -- name combined treatment variable `matchit_t, SELECT rest of columns`
  commandString := commandString || ')::INTEGER AS matchit_t, * FROM ' || sourceTable;

  -- create the OR combined treatment table
  RAISE NOTICE '%', commandString;
  EXECUTE commandString;

  allTreatmentsMatchedName := allTreatmentsName || '_matched';
  SELECT matchit_cem(
    allTreatmentsName,
    primaryKey,
    array_append(ARRAY[]::TEXT[], 'matchit_t'),
    uniqueCovariates,
    allTreatmentsMatchedName
  ) INTO resultString;
  
  matchedPk := quote_ident('subclass_' || primaryKey);
  treatmentIndex := 0;
  FOREACH treatment IN ARRAY treatmentsArr LOOP
    SELECT ARRAY(SELECT unnest(treatmentsArr[treatmentIndex:1])) INTO covariateArr;
    treatmentIndex := treatmentIndex + 1;

    SELECT matchit_cem(
      allTreatmentsMatchedName,
      matchedPk,
      array_append(ARRAY[]::TEXT[], treatment),
      covariateArr,
      outputTableBasename || '_' || treatment || '_matched'
    ) INTO resultStringTemp;

    -- combine result strings
    resultString := resultString || ' ' || resultStringTemp;
  END LOOP;

  RETURN resultString;
END;
$func$ LANGUAGE plpgsql;
