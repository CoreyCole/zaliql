CREATE OR REPLACE FUNCTION ate(
  matchedSourceTable TEXT,  -- input table name that was output by matchit
  outcome TEXT,             -- column name of the outcome of interest
  covariatesArr TEXT[],     -- array of covariate column names that were matched by matchit
  outputTable TEXT          -- name of table for results matrix
) RETURNS NUMERIC AS $func$
DECLARE

BEGIN

END;
$func$ LANGUAGE plpgsql;


SELECT treatedOutcomeAverage, controlOutcomeAverage, 