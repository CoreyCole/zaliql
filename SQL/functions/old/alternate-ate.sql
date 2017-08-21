SELECT ( ( treatedAvg1 * treatedCount1 ) + ( treatedAvg2 * treatedCount2 ) + ( treatedAvg3 * treatedCount3 ) ) / treatedCount - 
	   ( ( controlAvg1 * controlCount1 ) + ( controlAvg2 * controlCount2 ) + ( controlAvg3 * controlCount3 ) ) / controlCount AS ATE_after_matching, 
	   treatedCount1, treatedCount2, treatedCount3, controlCount1, controlCount2, controlCount3 FROM
	-- compute weighted average stats for treated groups
	(SELECT avg(depdelay) AS treatedAvg1, count(*) AS treatedCount1 FROM test_flight
		WHERE lowpressure = 1 AND thunder_matched = 0 AND snow_matched = 0 AND lowvisibility_matched = 0) as treated1, -- 1 0 0 0
	(SELECT avg(depdelay) AS treatedAvg2, count(*) AS treatedCount2 FROM test_flight
		WHERE lowpressure = 1 AND thunder_matched = 0 AND snow_matched = 0 AND lowvisibility_matched = 1) as treated2, -- 1 0 0 1
	(SELECT avg(depdelay) AS treatedAvg3, count(*) AS treatedCount3 FROM test_flight
		WHERE lowpressure = 1 AND thunder_matched = 0 AND snow_matched = 1 AND lowvisibility_matched = 0) as treated3, -- 1 0 1 0
  (SELECT avg(depdelay) AS treatedAvg4, count(*) AS treatedCount4 FROM test_flight
		WHERE lowpressure = 1 AND thunder_matched = 0 AND snow_matched = 1 AND lowvisibility_matched = 1) as treated4, -- 1 0 1 1
  (SELECT avg(depdelay) AS treatedAvg5, count(*) AS treatedCount5 FROM test_flight
		WHERE lowpressure = 1 AND thunder_matched = 1 AND snow_matched = 0 AND lowvisibility_matched = 0) as treated5, -- 1 1 0 0
  (SELECT avg(depdelay) AS treatedAvg6, count(*) AS treatedCount6 FROM test_flight
		WHERE lowpressure = 1 AND thunder_matched = 1 AND snow_matched = 0 AND lowvisibility_matched = 1) as treated6, -- 1 1 0 1
  (SELECT avg(depdelay) AS treatedAvg7, count(*) AS treatedCount7 FROM test_flight
		WHERE lowpressure = 1 AND thunder_matched = 1 AND snow_matched = 1 AND lowvisibility_matched = 1) as treated7, -- 1 1 1 1
	-- compute weighted average stats for control groups
	(SELECT avg(depdelay) AS controlAvg1, count(*) AS controlCount1 FROM test_flight
		WHERE lowpressure = 0 AND thunder_matched = 0 AND snow_matched = 0 AND lowvisibility_matched = 1) as control1,
	(SELECT avg(depdelay) AS controlAvg2, count(*) AS controlCount2 FROM test_flight
		WHERE lowpressure = 0 AND thunder_matched = 0 AND snow_matched = 0 AND lowvisibility_matched = 0) as control2,
	(SELECT avg(depdelay) AS controlAvg3, count(*) AS controlCount3 FROM test_flight
		WHERE lowpressure = 1 AND thunder_matched = 1 AND snow_matched = 0 AND lowvisibility_matched = 0) as control3,
	-- compute total counts of treated and control
	(SELECT count(*) AS treatedCount FROM test_flight WHERE thunder = 1) as treated,
	(SELECT count(*) as controlCount FROM test_flight WHERE thunder = 0) as control;