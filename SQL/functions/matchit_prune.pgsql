CREATE OR REPLACE FUNCTION matchit_prune(
  sourceTable TEXT,
  primaryKey TEXT,
  treatment TEXT,
  treatmentLevels INTEGER,
  covariateArr TEXT[]
) RETURNS TEXT[] AS $func$
DECLARE
  matchedCovariates TEXT[];
  commandString TEXT;
BEGIN
  commandString := array(
    SELECT column_name, count(distinct treatment)
    FROM information.schema.columns
    WHERE table_name=sourceTable AND
    covariateArr @> ARRAY[column_name] -- this means contains
    -- not sure?
    GROUP BY -- for loop covariates
    HAVING count(distinct treatment) = treatmentLevels

  )

  EXECUTE commandString INTO matchedCovariates;
  RETURN matchedCovariates;
END;
$func$ LANGUAGE plpgsql;
