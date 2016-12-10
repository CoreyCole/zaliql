CREATE OR REPLACE FUNCTION binEqualWidth_lalonde_age(_numIntervals integer)
  RETURNS TABLE(age integer, ageBin numrange) AS
$func$
DECLARE
  mviews RECORD;
  minAge integer;
  maxAge integer;
  binWidth numeric;
  currentRange numrange;
BEGIN
  SELECT MIN(l.age) INTO minAge FROM lalonde AS l;
  SELECT MAX(l.age) INTO maxAge FROM lalonde AS l;
  binWidth := 1.0*(maxAge - minAge) / _numIntervals;
  RAISE NOTICE 'minAge=% : maxAge=%', minAge, maxAge;
  RAISE NOTICE 'binWidth=%', binWidth;
  currentRange = numrange(minAge, minAge + binWidth, '[)');
  FOR mviews IN SELECT * FROM lalonde AS l ORDER BY l.age LOOP
    IF (mviews.age > upper(currentRange)) THEN
      currentRange = numrange(upper(currentRange), upper(currentRange) + binWidth, '[)');
    END IF;
    RAISE NOTICE 'rowAge=% : currentRange=[%,%)', mviews.age, lower(currentRange), upper(currentRange);
  END LOOP;
END;
$func$ LANGUAGE plpgsql;
