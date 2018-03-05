CREATE OR REPLACE FUNCTION get_columns(
  tableName TEXT
) RETURNS TEXT[] AS $func$
DECLARE
  commandString TEXT;
  resultsArr TEXT[];
BEGIN
  commandString := 'SELECT ARRAY('
    || ' SELECT column_name::TEXT'
    || ' FROM information_schema.columns'
    || ' WHERE table_name=''' || tableName || ''''
    || ')';
  EXECUTE commandString INTO resultsArr;
  RETURN resultsArr;
END;
$func$ LANGUAGE plpgsql;
