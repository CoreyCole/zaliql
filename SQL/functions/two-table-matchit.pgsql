CREATE OR REPLACE FUNCTION two_table_matchit(
  sourceTableA TEXT,
  sourceTableAPrimaryKey TEXT,
  sourceTableAForeignKey TEXT,
  covariatesArrA TEXT[],
  sourceTableB TEXT,
  sourceTableBPrimaryKey TEXT,
  covariatesArrB TEXT[],
  treatment TEXT,              -- treatment column must be in sourceTableA
  treatmentLevels INTEGER,
  outputTable TEXT
) RETURNS TEXT AS $func$
DECLARE
  intermediateTable TEXT;
  joinedTable TEXT;
  resultString TEXT;
  commandString TEXT;
BEGIN
  intermediateTable = outputTable || '_intermediate';
  joinedTable = outputTable || '_joined';

  commandString = 'DROP MATERIALIZED VIEW IF EXISTS ' || outputTable;
  EXECUTE commandString;
  commandString = 'DROP MATERIALIZED VIEW IF EXISTS ' || joinedTable;
  EXECUTE commandString;
  commandString = 'DROP MATERIALIZED VIEW IF EXISTS ' || intermediateTable;
  EXECUTE commandString;

  SELECT multi_level_treatment_matchit(
    sourceTableA,
    sourceTableAPrimaryKey,
    treatment,
    treatmentLevels,
    covariatesArrA,
    intermediateTable
  ) INTO resultString;

  commandString = 'CREATE MATERIALIZED VIEW ' || joinedTable
    || ' AS SELECT * FROM ' || intermediateTable
    || ' JOIN ' || sourceTableB || ' ON '
    || sourceTableB || '.' || sourceTableBPrimaryKey || ' = '
    || intermediateTable || '.' || sourceTableAForeignKey
    || ' WITH DATA;';
  EXECUTE commandString;

  RETURN multi_level_treatment_matchit(
    joinedTable,
    sourceTableBPrimaryKey,
    treatment,
    treatmentLevels,
    covariatesArrB,
    outputTable
  );
END;
$func$ LANGUAGE plpgsql;

SELECT count(distinct carrier) FROM demo_test_1000_flights;

SELECT two_table_matchit('demo_test_1000_flights', 'fid', 'flightWid', ARRAY['airlineid', 'carrier', 'dest'], 'demo_test_1000_weather', 'wid', ARRAY['fog', 'hail', 'hum', 'rain', 'snow'], 'carrier', 3, 'two_table_test');

DROP TABLE demo_test_1000_weather;
DROP TABLE demo_test_1000_flights;

CREATE TABLE demo_test_1000_weather (
	wid INTEGER PRIMARY KEY,
	code TEXT,
	fog BIT,
	hail BIT,
	hour INTEGER,
	hum INTEGER,
	precipm NUMERIC,
	pressurem NUMERIC,
	rain BIT,
	snow BIT,
	tempm NUMERIC,
	thunder BIT,
	vism NUMERIC,
	wspdm NUMERIC
);
INSERT INTO demo_test_1000_weather (wid, code, fog, hail, hour, hum, precipm, pressurem, rain, snow, tempm, thunder, vism, wspdm)
SELECT DISTINCT wid::INTEGER, code, fog::BIT, hail::BIT, hour::INTEGER, hum::INTEGER, precipm::NUMERIC, pressurem::NUMERIC, rain::BIT, snow::BIT, tempm::NUMERIC, thunder::BIT, vism::NUMERIC, wspdm::NUMERIC
FROM demo_test_1000;

CREATE TABLE demo_test_1000_flights (
	fid INTEGER PRIMARY KEY,
	flightWid INTEGER REFERENCES demo_test_1000_weather(wid),
	yyear INTEGER,
	quarter INTEGER,
	month INTEGER,
	dayofweek INTEGER,
	uniquecarrier TEXT,
	airlineid INTEGER,
	carrier TEXT,
	dest TEXT,
	crsdeptime TEXT,
	depdelay INTEGER,
	depdel15 BIT
);
INSERT INTO demo_test_1000_flights (fid, flightWid, yyear, quarter, month, dayofweek, uniquecarrier, airlineid, carrier, dest, crsdeptime, depdelay, depdel15)
SELECT fid::INTEGER, wid::INTEGER, yyear::INTEGER, quarter::INTEGER, month::INTEGER, dayofweek::INTEGER, uniquecarrier, airlineid::INTEGER, carrier, dest, crsdeptime, depdelay::INTEGER, depdel15::BIT FROM demo_test_1000;
