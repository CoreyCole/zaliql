CREATE OR REPLACE FUNCTION binEqualWidth(table _t text, column _c text, _numIntervals integer)
  RETURNS TABLE AS
$func$
BEGIN
  -- use format function to prevent SQL injection
  const char *stmt = format('SELECT %I FROM %I ORDER BY %I ASC', _c, _t, _c)
  -- maybe use wildcards to execute dynamic SQL query instead of format
  -- documentation link: https://www.postgresql.org/docs/9.1/static/ecpg-dynamic.html

  -- use CURSOR to point to multiple rows returned from dynamic SQL
  EXEC SQL DECLARE cursor1 CURSOR FOR stmt1;
  EXEC SQL OPEN cursor1;

  EXEC SQL WHENEVER NOT FOUND DO BREAK;

  while(1) {
    EXEC SQL FETCH cursor1
  }

  EXEC SQL PREPARE mystmt FROM :stmt;
