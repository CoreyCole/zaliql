CREATE OR REPLACE FUNCTION matchit(
  sourceTable TEXT,     -- input table name
  primaryKey TEXT,      -- source table's primary key
  treatmentsArr TEXT[], -- array of treatment column names
  covariatesArr TEXT[], -- array covariate column names (all covariates are applied to all treatments)
  method TEXT,          -- matching method (either cem or ps for Propensity Score)
  outputTable TEXT      -- output table name
) RETURNS TEXT AS $func$
BEGIN
  CASE method
    WHEN 'cem' THEN
      RETURN matchit_cem(
        sourceTable,
        primaryKey,
        treatmentsArr,
        covariatesArr,
        method,
        outputTable
      );
    WHEN 'ps' THEN
      RETURN matchit_propensity_score(
        sourceTable,
        primaryKey,
        treatmentsArr,
        covariatesArr,
        method,
        outputTable
      );
  END CASE;
END;
$func$ LANGUAGE plpgsql;
