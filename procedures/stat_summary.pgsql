CREATE OR REPLACE FUNCTION stat_summary(
  source_table TEXT,  -- input table name
  verbose BOOLEAN,    -- (optional) print to std out
  target_cols TEXT,   -- comma-separated covariate column names
  output_table TEXT   -- output table name
) RETURNS TEXT AS $fun
BEGIN

END;
$func$ LANGUAGE plpgsql;

/*
(SELECT * FROM (
	(SELECT *, (avg_treated - avg_untreated) AS mean_diff FROM
		(
			(SELECT avg(dewpti::NUMERIC) AS avg_treated, stddev_pop(dewpti::NUMERIC) AS stddev_treated FROM test_flight WHERE treated::NUMERIC = 1) AS dewpti_treated
			CROSS JOIN
			(SELECT avg(dewpti::NUMERIC) AS avg_untreated, stddev_pop(dewpti::NUMERIC) AS stddev_untreated FROM test_flight WHERE treated::NUMERIC = 0) AS dewpti_untreated
		) AS dewpti_stats
	)
) AS dewpti)
UNION ALL
(SELECT * FROM (
	(SELECT *, (avg_treated - avg_untreated) AS mean_diff FROM
		(
			(SELECT avg(wspdm::NUMERIC) AS avg_treated, stddev_pop(wspdm::NUMERIC) AS stddev_treated FROM test_flight WHERE treated::NUMERIC = 1) AS wspdm_treated
			CROSS JOIN
			(SELECT avg(wspdm::NUMERIC) AS avg_untreated, stddev_pop(wspdm::NUMERIC) AS stddev_untreated FROM test_flight WHERE treated::NUMERIC = 0) AS wspdm_untreated
		) AS wspdm_stats
	)
) AS wspdm);
*/