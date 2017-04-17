/*
count(distict treatment)
  group by covariates
  having count(distict treatment) = 5
*/

CREATE OR REPLACE FUNCTION matchit(
  source_tables TEXT,        -- space separated input table names
  primary_keys TEXT,         -- space separated source tables' primary keys
  treatment TEXT,            -- treatment column name (prefixed with it's table name)
  covariates TEXT,           -- space separated covariate column names (prefixed with their column names)
  output_table TEXT          -- output table name
) RETURNS TEXT AS $func$
DECLARE
  commandString TEXT;
  numGroups INTEGER;
  numDiscarded INTEGER;
  covariatesArr TEXT[];
  covariate TEXT;
  sourceTable TEXT;
  sourceTablesArr TEXT[];
  columnName TEXT[];
  primaryKeysArr TEXT[];
BEGIN
  SELECT regexp_split_to_array(covariates, '\s+') INTO covariatesArr;
  SELECT regexp_split_to_array(source_tables, '\s+') INTO sourceTablesArr;
  SELECT regexp_split_to_array(primary_keys, '\s+') INTO primaryKeysArr;

  commandString := 'WITH subclasses as (SELECT'
    || ' max(' || quote_ident(primaryKeysArr[0]) || ') AS subclass,'
    || ' count(distinct ' || quote_ident(treatment) || '::NUMERIC)';
  
  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString = commandString || ', ' || quote_ident(covariate) || ' AS ' || quote_ident(covariate) || '_matched';
  END LOOP;

  commandString = commandString || ' FROM ';

  -- add source tables
  FOREACH sourceTable IN ARRAY sourceTablesArr LOOP
    commandString = commandString || sourceTable || ', ';
  END LOOP;

  -- chop off last `, ` from source tables list
  commandString = substring( commandString from 0 for (char_length(commandString) - 2) );

  commandString = commandString || ' GROUP BY ';

  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString = commandString || quote_ident(covariate) || '_matched, ';
  END LOOP;

  -- use substring here to chop off last comma
  commandString = substring( commandString from 0 for (char_length(commandString) - 1) );
    
  commandString = commandString || ' HAVING count(distinct' || quote_ident(treatment) || '::NUMERIC) != min(' || quote_ident(treatment) || '::NUMERIC)'
    || ') SELECT * FROM subclasses, ';

  -- add source tables
  FOREACH sourceTable IN ARRAY sourceTablesArr LOOP
    commandString = commandString || sourceTable || ', ';
  END LOOP;

  -- chop off last `, ` from source tables list
  commandString = substring( commandString from 0 for (char_length(commandString) - 2) );

  commandString = commandString || ' WHERE';

  FOREACH covariate IN ARRAY covariatesArr LOOP
    SELECT split_part(covariate, '.', 2) INTO columnName;
    RAISE NOTICE '%', covariate;
    RAISE NOTICE '%', columnName;
    commandString = commandString || ' subclasses.' || quote_ident(covariate) || '_matched = st.' || quote_ident(covariate) || ' AND';
  END LOOP;

  -- use substring here to chop off last `AND`
  commandString = substring( commandString from 0 for (char_length(commandString) - 3) );

  EXECUTE format('DROP MATERIALIZED VIEW IF EXISTS %s', output_table);

  commandString = 'CREATE MATERIALIZED VIEW ' || output_table
    || ' AS ' || commandString || ' WITH DATA;';
  RAISE NOTICE '%', commandString;
  -- EXECUTE commandString;

  RETURN 'Match successful and materialized in ' || output_table || '!';
END;
$func$ LANGUAGE plpgsql;

SELECT matchit('demo_test_1000 demo_test_10000', 'demo_test_1000.fid demo_test_10000.fid', 'thunder', 'demo_test_1000.fog demo_test_1000.hail demo_test_10000.rain demo_test_10000.snow demo_test_10000.tornado', 'test_flight2');

DROP FUNCTION matchit(text,text,text,text,text,text,text,boolean);

