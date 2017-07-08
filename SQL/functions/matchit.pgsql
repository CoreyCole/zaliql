CREATE OR REPLACE FUNCTION matchit(
  sourceTablesArr TEXT[],        -- input table names arr
  primaryKeysArr TEXT[],         -- source tables' primary keys arr
  treatment TEXT,                -- treatment column name (prefixed with it's table name - `tableName.columnName`)
  treatmentLevels INTEGER,
  covariatesArr TEXT[],          -- space separated covariate column names (prefixed with their table names - `tableName.columnName`)
  output_table TEXT              -- output table name
) RETURNS TEXT AS $func$
DECLARE
  commandString TEXT;
  numGroups INTEGER;
  numDiscarded INTEGER;
  -- covariatesArr TEXT[];
  covariate TEXT;
  sourceTable TEXT;
  -- sourceTablesArr TEXT[];
  columnName TEXT;
  -- primaryKeysArr TEXT[];
BEGIN
  -- SELECT regexp_split_to_array(covariates, '\s+') INTO covariatesArr;
  -- SELECT regexp_split_to_array(source_tables, '\s+') INTO sourceTablesArr;
  -- SELECT regexp_split_to_array(primary_keys, '\s+') INTO primaryKeysArr;
  commandString := 'WITH subclasses as (SELECT '
    || ' max(' || primaryKeysArr[1] || ') AS subclass,'
    || ' count(distinct ' || treatment || '::NUMERIC)';
  
  FOREACH covariate IN ARRAY covariatesArr LOOP
    SELECT split_part(covariate, '.', 2) INTO columnName;
    commandString = commandString || ', ' || covariate || ' AS ' || columnName || '_matched';
  END LOOP;

  commandString = commandString || ' FROM ';

  -- add source tables
  FOREACH sourceTable IN ARRAY sourceTablesArr LOOP
    commandString = commandString || sourceTable || ', ';
  END LOOP;

  -- chop off last `, ` from source tables list
  commandString = substring( commandString from 0 for (char_length(commandString) - 1) );

  commandString = commandString || ' GROUP BY ';

  FOREACH covariate IN ARRAY covariatesArr LOOP
    SELECT split_part(covariate, '.', 2) INTO columnName;
    commandString = commandString || columnName || '_matched, ';
  END LOOP;

  -- use substring here to chop off last comma
  commandString = substring( commandString from 0 for (char_length(commandString) - 1) );
    
  commandString = commandString || ' HAVING count(distinct ' || treatment || '::INTEGER)::INTEGER = ' || treatmentLevels
    || ') SELECT ';

  -- FOR LOOP TABLE NAME . *
  FOREACH sourceTable IN ARRAY sourceTablesArr LOOP
    FOR columnName IN EXECUTE 'SELECT column_name FROM information_schema.columns WHERE'
        || ' table_name = ''' || quote_ident(sourceTable) || ''''
      LOOP
        commandString = commandString || sourceTable || '.' || columnName || ' AS ' || sourceTable || '_' || columnName || ', ';
      END LOOP;
  END LOOP;

  -- use substring here to chop off last comma
  commandString = substring( commandString from 0 for (char_length(commandString) - 1) );

  commandString = commandString || ' FROM subclasses, ';

  -- add source tables
  FOREACH sourceTable IN ARRAY sourceTablesArr LOOP
    commandString = commandString || sourceTable || ', ';
  END LOOP;

  -- chop off last `, ` from source tables list
  commandString = substring( commandString from 0 for (char_length(commandString) - 1) );

  commandString = commandString || ' WHERE';

  FOREACH covariate IN ARRAY covariatesArr LOOP
    SELECT split_part(covariate, '.', 2) INTO columnName;
    commandString = commandString || ' subclasses.' || columnName || '_matched = ' || covariate || ' AND';
  END LOOP;

  -- use substring here to chop off last `AND`
  commandString = substring( commandString from 0 for (char_length(commandString) - 3) );
  -- EXECUTE format('DROP MATERIALIZED VIEW IF EXISTS %s', output_table);

  commandString = 'CREATE MATERIALIZED VIEW ' || output_table
    || ' AS ' || commandString || ' WITH DATA;';
  EXECUTE commandString;

  RETURN 'Match successful and materialized in ' || output_table || '!';
END;
$func$ LANGUAGE plpgsql;

SELECT matchit(ARRAY['demo_test_1000', 'demo_test_10000'], ARRAY['demo_test_1000.fid', 'demo_test_10000.fid'], 'demo_test_1000.thunder', 2, ARRAY['demo_test_1000.fog', 'demo_test_1000.hail', 'demo_test_10000.rain', 'demo_test_10000.snow', 'demo_test_10000.tornado'], 'test_flight2');

DROP FUNCTION matchit(text,text,text,text,text,text,text,boolean);

SELECT column_name FROM information_schema.columns WHERE table_name = 'demo_test_1000';