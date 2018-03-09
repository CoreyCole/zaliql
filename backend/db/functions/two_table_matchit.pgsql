-- remove treatment levels here also

CREATE OR REPLACE FUNCTION two_table_matchit(
  sourceTableA TEXT,           -- input table A name
  sourceTableAPrimaryKey TEXT, -- input table A primary key
  sourceTableAForeignKey TEXT, -- foreign key linking to input table B
  covariatesArrA TEXT[],       -- covariates included in input table A
  sourceTableB TEXT,           -- input table B name
  sourceTableBPrimaryKey TEXT, -- input table B primary key
  covariatesArrB TEXT[],       -- covariates included in input table B
  treatment TEXT,              -- treatment column must be in sourceTableA
  treatmentLevels INTEGER,     -- possible levels for given treatment
  outputTable TEXT             -- output table name
) RETURNS TEXT AS $func$
DECLARE
  intermediateTable TEXT;
  joinedTable TEXT;
  resultString TEXT;
  commandString TEXT;
BEGIN
  intermediateTable = outputTable || '_intermediate';
  joinedTable = outputTable || '_joined';

  commandString = 'DROP MATERIALIZED VIEW IF EXISTS ' || outputTable;
  EXECUTE commandString;
  commandString = 'DROP MATERIALIZED VIEW IF EXISTS ' || joinedTable;
  EXECUTE commandString;
  commandString = 'DROP MATERIALIZED VIEW IF EXISTS ' || intermediateTable;
  EXECUTE commandString;

  SELECT multi_level_treatment_matchit(
    sourceTableA,
    sourceTableAPrimaryKey,
    treatment,
    treatmentLevels,
    covariatesArrA,
    intermediateTable
  ) INTO resultString;

  commandString = 'CREATE MATERIALIZED VIEW ' || joinedTable
    || ' AS SELECT * FROM ' || intermediateTable
    || ' JOIN ' || sourceTableB || ' ON '
    || sourceTableB || '.' || sourceTableBPrimaryKey || ' = '
    || intermediateTable || '.' || sourceTableAForeignKey
    || ' WITH DATA;';
  EXECUTE commandString;

  RETURN multi_level_treatment_matchit(
    joinedTable,
    sourceTableBPrimaryKey,
    treatment,
    treatmentLevels,
    covariatesArrB,
    outputTable
  );
END;
$func$ LANGUAGE plpgsql;
