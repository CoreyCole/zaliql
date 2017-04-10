CREATE OR REPLACE FUNCTION L1_func(
  source_table TEXT,
  treatment TEXT,
  covariates TEXT     -- space separated covariates
) RETURNS NUMERIC AS $func$
DECLARE
  commandString TEXT;
  recordVar RECORD;
  currentControl BOOLEAN;
  controlCount INTEGER;
  sumTotal NUMERIC;
BEGIN
  commandString := 'SELECT count(*) as numCount, thunder, ew_binned_depdelayminutes, ew_binned_distance, ew_binned_vism'
    || ' FROM test_flight_matched'
    || ' GROUP BY thunder, ew_binned_depdelayminutes, ew_binned_distance, ew_binned_vism'
    || ' ORDER BY ew_binned_depdelayminutes, ew_binned_distance, ew_binned_vism, thunder';

  sumTotal := 0.0;
  currentControl := TRUE;
  controlCount := 0;

  FOR recordVar IN EXECUTE commandString LOOP
    IF currentControl THEN
      currentControl = FALSE;

      controlCount = recordVar.numCount;

      RAISE NOTICE 'currentControl = % (%) | controlCount = %', currentControl, recordVar.thunder, controlCount;
    ELSE
      currentControl = TRUE;

      -- @ is absolute value in plpgsql
      sumTotal = sumTotal + @( controlCount/groupSize - recordVar.numCount ) * (controlCount + recordVar.numCount) / ;

      RAISE NOTICE 'currentControl = % (%) | sumTotal += abs( % - % ) | sumTotal = %', currentControl, recordVar.thunder, controlCount, recordVar.numCount, sumTotal;
    END IF;
  END LOOP;

  RETURN 0.5 * sumTotal;
END;
$func$ LANGUAGE plpgsql;
