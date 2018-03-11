CREATE OR REPLACE FUNCTION matchit_cem(
  sourceTable TEXT,     -- input table name
  primaryKey TEXT,      -- source table's primary key
  treatmentsArr TEXT[], -- array of treatment column names
  covariatesArr TEXT[], -- array of covariate column names (all covariates are applied to all treatments)
  outputTable TEXT      -- output table name
) RETURNS TEXT AS $func$
DECLARE
  commandString TEXT;
  treatmentLevels INTEGER[];
  treatmentLevel INTEGER;
  treatment TEXT;
  treatmentIndex INTEGER;
  covariate TEXT;
  columnName TEXT;
BEGIN
  -- compute the distinct levels of the given treatment variable
  treatmentIndex := 0;
  FOREACH treatment IN ARRAY treatmentsArr LOOP
    commandString := 'SELECT count(DISTINCT ' || quote_ident(treatment) || ')::INTEGER FROM ' 
      || quote_ident(sourceTable);
    EXECUTE commandString INTO treatmentLevel;
    treatmentLevels[treatmentIndex] := treatmentLevel;
    treatmentIndex := treatmentIndex + 1;
  END LOOP;

  commandString := 'WITH subclasses as (SELECT '
    || ' max(' || quote_ident(primaryKey) || ') AS ' || quote_ident('subclass_' || primaryKey);

  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString := commandString || ', ' || quote_ident(covariate) || ' AS ' 
      || quote_ident(covariate || '_matched');
  END LOOP;

  commandString := commandString || ' FROM ' || quote_ident(sourceTable) || ' GROUP BY ';

  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString := commandString || quote_ident(covariate || '_matched') || ', ';
  END LOOP;

  -- use substring here to chop off last comma
  commandString := substring( commandString from 0 for (char_length(commandString) - 1) );
  
  commandString := commandString || ' HAVING (';
  treatmentIndex := 0;
  FOREACH treatment IN ARRAY treatmentsArr LOOP
    commandString := commandString || 'count(DISTINCT ' || quote_ident(treatment) || ') = '
      || treatmentLevels[treatmentIndex] || ' OR ';
    treatmentIndex := treatmentIndex + 1;
  END LOOP;

  -- use substring here to chop off last OR
  commandString := substring( commandString from 0 for (char_length(commandString) - 3) );

  commandString := commandString || ')) SELECT * FROM subclasses, ' || quote_ident(sourceTable) || ' st WHERE';

  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString := commandString || ' subclasses.' || quote_ident(covariate || '_matched')
      || ' = st.' || quote_ident(covariate) || ' AND';
  END LOOP;

  commandString := commandString || ' ' || quote_ident(treatment) || ' IS NOT NULL';

  -- EXECUTE format('DROP MATERIALIZED VIEW IF EXISTS %s', outputTable);

  commandString := 'CREATE TABLE ' || quote_ident(outputTable)
    || ' AS ' || commandString;
  RAISE NOTICE '%', commandString;
  EXECUTE commandString;

  RETURN 'Coarsened exact matching successful and output in table ' || quote_ident(outputTable) || '!';
END;
$func$ LANGUAGE plpgsql;
