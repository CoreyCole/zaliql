CREATE OR REPLACE FUNCTION matchit(
  sourceTable TEXT,     -- input table name
  primaryKey TEXT,      -- source table's primary key
  treatmentsArr TEXT[], -- array of treatment column names
  covariatesArr TEXT[], -- array of covariate column names (all covariates are applied to all treatments)
  outputTable TEXT      -- output table name
) RETURNS TEXT AS $func$
DECLARE
  commandString TEXT;
  treatment TEXT;
  covariate TEXT;
  columnName TEXT;
BEGIN
  commandString := 'WITH subclasses as (SELECT '
    || ' max(' || primaryKey || ') AS subclass_' || primaryKey;

  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString = commandString || ', ' || quote_ident(covariate) || ' AS ' || quote_ident(covariate) || '_matched';
  END LOOP;

  commandString = commandString || ' FROM ' || quote_ident(sourceTable) || ' GROUP BY ';

  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString = commandString || quote_ident(covariate) || '_matched, ';
  END LOOP;

  -- use substring here to chop off last comma
  commandString = substring( commandString from 0 for (char_length(commandString) - 1) );
  
  commandString = commandString || ' HAVING (';
  FOREACH treatment IN ARRAY treatmentsArr LOOP
    commandString = commandString || 'max(' || treatment || ') != min(' || treatment || ') OR ';
  END LOOP;

  -- use substring here to chop off last OR
  commandString = substring( commandString from 0 for (char_length(commandString) - 3) );

  commandString = commandString || ')) SELECT * FROM subclasses, ' || quote_ident(sourceTable) || ' st WHERE';

  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString = commandString || ' subclasses.' || quote_ident(covariate) || '_matched = st.' || quote_ident(covariate) || ' AND';
  END LOOP;

  -- use substring here to chop off last `AND`
  commandString = substring( commandString from 0 for (char_length(commandString) - 3) );

  -- EXECUTE format('DROP MATERIALIZED VIEW IF EXISTS %s', outputTable);

  commandString = 'CREATE MATERIALIZED VIEW ' || outputTable
    || ' AS ' || commandString || ' WITH DATA;';
  RAISE NOTICE '%', commandString;
  EXECUTE commandString;

  RETURN 'Match successful and materialized in ' || outputTable || '!';
END;
$func$ LANGUAGE plpgsql;

DROP MATERIALIZED VIEW IF EXISTS test_flight;

SELECT matchit('demo_data_1000000', 'fid', ARRAY['lowpressure'], ARRAY['rain', 'fog'], 'test_flight');

SELECT rain_matched, fog_matched, count(*), avg(depdelay) FROM test_flight GROUP BY rain_matched, fog_matched ORDER BY rain_matched, fog_matched;

SELECT * FROM test_flight;

DROP FUNCTION matchit(text,text,text[],text[],text);

SELECT column_name FROM information_schema.columns WHERE table_name = 'demo_test_1000';