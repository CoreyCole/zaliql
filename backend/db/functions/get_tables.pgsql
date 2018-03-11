CREATE OR REPLACE FUNCTION get_tables()
RETURNS TEXT[] AS $func$
DECLARE
  commandString TEXT;
  resultsArr TEXT[];
BEGIN
  commandString := 'SELECT ARRAY('
    || ' SELECT table_name::TEXT'
    || ' FROM information_schema.tables'
    || ' WHERE table_schema=''public'' OR table_schema=''madlib'' AND table_type=''BASE TABLE'''
    || ')';
  EXECUTE commandString INTO resultsArr;

  RETURN resultsArr;
END;
$func$ LANGUAGE plpgsql;