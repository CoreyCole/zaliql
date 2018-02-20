CREATE OR REPLACE FUNCTION ate(
  sourceTable TEXT,    -- input table name that was output by matchit
  outcome TEXT,        -- column name of the outcome of interest
  treatment TEXT,      -- column name of the treatment of interest
  covariatesArr TEXT[] -- array of covariate column names
) RETURNS NUMERIC AS $func$
DECLARE
  commandString TEXT;
  covariate TEXT;
  currentRow RECORD;
  prevRow RECORD;
  isTreatedRow BOOLEAN;
  weightedAvgTreated NUMERIC;
  weightedAvgControl NUMERIC;
  countTreated INTEGER;
  countControl INTEGER;
BEGIN
  commandString = 'SELECT ' || treatment || ' AS treatment, ';

  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString = commandString || covariate || ', ';
  END LOOP;

  commandString = commandString || 'count(*) AS groupSize, avg(' || outcome || ') AS avgOutcome'
    || ' FROM ' || sourceTable
    || ' WHERE ' || treatment || ' IS NOT NULL'
    || ' GROUP BY ' || treatment || ', ';

  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString = commandString || covariate || ', ';
  END LOOP;

  -- use substring here to chop off last comma
  commandString = substring( commandString from 0 for (char_length(commandString) - 1) );

  commandString = commandString || ' ORDER BY ';

  FOREACH covariate IN ARRAY covariatesArr LOOP
    commandString = commandString || covariate || ', ';
  END LOOP;

  commandString = commandString || treatment;

  isTreatedRow = FALSE;
  weightedAvgTreated = 0.0;
  weightedAvgControl = 0.0;
  countTreated = 0;
  countControl = 0;
  prevRow = row(NULL);
  FOR currentRow IN EXECUTE commandString LOOP
    isTreatedRow = currentRow.treatment::BOOLEAN;
    IF (isTreatedRow AND prevRow IS NOT NULL) THEN
      IF (currentRow.avgOutcome IS NOT NULL AND prevRow.avgOutcome IS NOT NULL
          AND currentRow.groupSize >= 1 AND prevRow.groupSize >= 1) THEN
        weightedAvgTreated = weightedAvgTreated + currentRow.avgOutcome * currentRow.groupSize;
        weightedAvgControl = weightedAvgControl + prevRow.avgOutcome * prevRow.groupSize;
        countTreated = countTreated + currentRow.groupSize;
        countControl = countControl + prevRow.groupSize;
        RAISE NOTICE 'successful treatment/control pair
          treatedGroupSize: %
          controlGroupSize: %
          treatedGroupAvg: %
          controlGroupAvg: %',
          currentRow.groupSize, prevRow.groupSize, currentRow.avgOutcome, prevRow.avgOutcome;
        END IF;
    ELSIF NOT isTreatedRow THEN
      prevRow = currentRow;
    ELSE
      RAISE NOTICE 'invalid treatment/control pair
        treatedGroupSize: %
        controlGroupSize: %
        treatedGroupAvg: %
        controlGroupAvg: %',
        currentRow.groupSize, prevRow.groupSize, currentRow.avgOutcome, prevRow.avgOutcome;
    END IF;
  END LOOP;

  RETURN weightedAvgTreated / countTreated - weightedAvgControl / countControl;

END;
$func$ LANGUAGE plpgsql;
