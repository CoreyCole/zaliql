CREATE OR REPLACE FUNCTION multi_way_matchit(
  sourceTable TEXT,              -- input table name
  primaryKey TEXT,               -- space separated source tables' primary keys
  treatementArr TEXT[],          -- text array of treatment columns
  treatmentLevelsArr INTEGER[],  -- 2 for binary treatments
  covariateArr TEXT[][]          -- 2D text array of covariates (tableName.columnName)
) RETURNS TEXT[] AS $func$
DECLARE
  treatment TEXT;
  sourceTable TEXT;
  columnName TEXT;
  index INTEGER;
BEGIN

  index := 0;
  matchedCovariates := covariateArr[0];
  FOREACH treatment IN ARRAY treatmentArr LOOP
    matchedCovariates = matchit_prune(
      sourceTable,
      primaryKey,
      treatment,
      treatmentLevelsArr[index];
      matchedCovariates
    );
    index = index + 1;
    if (index < array_length(treatmentLevelsArr, 1)) {
      matchedCovariates = array_cat(matchedCovariates, covariateArr[index]);
    }
  END LOOP;
END;
$func$ LANGUAGE plpgsql;