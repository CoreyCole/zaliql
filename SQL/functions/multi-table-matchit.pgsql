CREATE OR REPLACE FUNCTION multi_table_matchit(
  sourceTableArr TEXT[],        -- text array of input table names
  primaryKeyArr TEXT[],         -- space separated source tables' primary keys
  treatment TEXT,               -- treatment column name (must be in sourceTableArr[0])
  treatmentLevels INTEGER,      -- 2 for binary treatment
  covariateArr TEXT[][]         -- 2D text array of covariates (tableName.columnName)
) RETURNS TEXT AS $func$
DECLARE
  covariate TEXT;
  sourceTable TEXT;
  columnName TEXT;
  index INTEGER;
  matchedCovariates TEXT[];
BEGIN
  index := 0;
  matchedCovariates := covariateArr[0];
  matchedRelation := sourceTable[0];
  FOREACH sourceTable IN ARRAY sourceTablesArr LOOP
    -- matchit_prune will return the TEXT[] non-discarded subset of covariates
    matchedCovariates = matchit_prune(
      matchedRelation,
      primaryKeyArr[index],
      treatment,
      treatmentLevels,
      matchedCovariates
    );
    index = index + 1;
    if (index < array_length(sourceTablesArr, 1)) { -- 1 is because 1D array
      matchedCovariates = array_cat(matchedCovariates, covariateArr[index]);  -- consider using array_agg here (quadratic runtime with array_cat)
      -- https://blog.heapanalytics.com/creating-postgresql-arrays-without-a-quadratic-blowup/
      matchedRelation = sourceTable[index]; -- need cross join here to combine the
      -- just-created materialized view with the next source table?
      -- or only materialize at the end when we know the valid covariates?
    }
  END LOOP;
END;
$func$ LANGUAGE plpgsql;
