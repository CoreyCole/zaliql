CREATE OR REPLACE FUNCTION get_columns(
  table_name TEXT
) RETURNS TEXT[] AS $func$
DECLARE
  command_string TEXT;
  results_arr TEXT[];
BEGIN
  command_string := 'SELECT ARRAY('
    || ' SELECT column_name::TEXT'
    || ' FROM information_schema.columns'
    || ' WHERE table_name=''' || quote_ident(table_name) || ''''
    || ')';
  EXECUTE command_string INTO results_arr;
  RETURN results_arr;
END;
$func$ LANGUAGE plpgsql;
