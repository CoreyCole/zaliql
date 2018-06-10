CREATE OR REPLACE FUNCTION get_tables()
RETURNS TEXT[] AS $func$
DECLARE
  command_string TEXT;
  results_arr TEXT[];
BEGIN
  command_string := 'SELECT ARRAY('
    || ' SELECT table_name::TEXT'
    || ' FROM information_schema.tables'
    || ' WHERE table_schema=''public'' OR table_schema=''madlib'' AND table_type=''BASE TABLE'''
    || ' ORDER BY table_name'
    || ')';
  EXECUTE command_string INTO results_arr;

  RETURN results_arr;
END;
$func$ LANGUAGE plpgsql;