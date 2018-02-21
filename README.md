TODO:
- get demo flight data in docker `flights_weather_demo`
- test all functions in readme
  - test multi-level-treatment matchit with carrier treatment

# ZaliSQL
A SQL-Based Framework for Drawing Causal Inference from Big Data
### Table of Contents
- [Demo](https://gitlab.cs.washington.edu/bsalimi/ZaliSQL#Demo)
- [Preprocessing](https://gitlab.cs.washington.edu/bsalimi/ZaliSQL#Preprocessing)
- [Matching](https://gitlab.cs.washington.edu/bsalimi/ZaliSQL#Matching)
- [Analysis](https://gitlab.cs.washington.edu/bsalimi/ZaliSQL#Analysis)

# Demo
The only external dependency for ZaliQL is [Docker](https://docs.docker.com/install/#supported-platforms). It allows anyone with docker installed on their machine to spin up a containerized stack with all of the internal dependencies and demo data automatically installed.

### These containers include:
- app: the python webserver (port 5000)
  - The python webserver is instantiated with the anaconda distribution packages on python version 3.6.4

- db: a postgres database (port 5432)
  - The postgres database is version 9.6 and comes pre-populated with demo data along with ZaliQLs and Madlib's function libraries

- redis: an in memory cache for certain user experience features

To spin up the containerized stack, use `docker-compose`:
```bash
docker-compose -f backend/docker/docker-compose.yml up -d --build
# NOTE: this takes some time, message "localhost:5432 - rejecting connections" is expected
```

To see what containers are running on your host machine:
```bash
docker ps -a
# Should see something like...
# NAMES
# docker_app_1
# docker_db_1
# docker_redis_1
```

To see the live-logs for one of the containers:
```bash
# python
docker-compose -f backend/docker/docker-compose.yml logs -t -f app
# database
docker-compose -f backend/docker/docker-compose.yml logs -t -f app
```

To ssh into one of the containers using a bash interface:
```bash
# python
docker exec -it docker_app_1 bash
# database
docker exec -it docker_db_1 bash
```

To connect to the database from a client like `postico`
- host: localhost
- user: madlib
- password: password
- database: maddb

# Preprocessing
## Binning
ZaliQL's `bin_equal_width` function materializes a view where the provided continuous-data columns are split into intervals of a prescribed width.
```sql
CREATE FUNCTION bin_equal_width(
  source_table TEXT,    -- input table name
  target_columns TEXT,  -- space separated list of continuous column names to bin
  output_table TEXT,    -- output table name
  num_bins TEXT         -- space separated list of prescribed number of bins, correspond to target_columns
) RETURNS TEXT

-- example call splitting `distance` into 10 bins and `vism` into 9
SELECT bin_equal_width(
  'flights_weather_demo',
  'distance vism',
  'equal_width_binned_flights_weather',
  '10 9'
);
```
TODO: `bin_quantile`, `bin_equal_frequency`

# Matching
ZaliSQL's matching functions are modeled after the R packages [MatchIt](https://cran.r-project.org/web/packages/MatchIt/MatchIt.pdf) and [CEM](https://cran.r-project.org/web/packages/cem/cem.pdf). Matching is a statistical method that makes the estimation of
causal effect less model-dependant and biased. After preprocessing data with matching methods, researchers can use whatever parametric model they would have used without matching, but produce inferences with substantially more robustness and less sensitivity to modeling assumptions.

## MatchIt
ZaliQL's `matchit` function currently supports 2 matching methods: `cem` (coarsened exact matching) and `ps` (propensity score matching). Propensity score matching only supports 1 treatment.
```sql
CREATE FUNCTION matchit(
  sourceTable TEXT,     -- input table name
  primaryKey TEXT,      -- source table's primary key
  treatmentsArr TEXT[], -- array of treatment column names
  covariatesArr TEXT[], -- array covariate column names (all covariates are applied to all treatments)
  method TEXT,          -- matching method (either 'cem' or 'ps')
  outputTable TEXT      -- output table name
) RETURNS TEXT

-- example call with propensity score matching
SELECT matchit(
  'flights_weather_demo',
  'fid',
  ARRAY['lowpressure'],
  ARRAY['fog', 'hail', 'hum', 'rain', 'snow'],
  'ps',
  'propensity_score_matchit_flights_weather'
);
```

ZaliQL's `multi_level_treatment_matchit` function is a variation of CEM matchit where the treatment variable is non-binary.
```sql
CREATE FUNCTION multi_level_treatment_matchit(
  sourceTable TEXT,        -- input table name
  primaryKey TEXT,         -- source table's primary key
  treatment TEXT,          -- treatment column name
  treatmentLevels INTEGER, -- possible levels for given treatment
  covariatesArr TEXT[],    -- array of covariate column names for given treatment
  outputTable TEXT         -- output table name
) RETURNS TEXT

-- example call
SELECT multi_level_treatment_matchit(
  'flights_weather_demo',
  'fid',
  'carrier',
  3,
  ARRAY['fog', 'hail', 'hum', 'rain', 'snow'],
  'multi_level_treatment_matchit_flights_weather'
);
```

ZaliQL's `multi_treatment_matchit` function is a variation of CEM matchit where there are multiple treatment variables the analyst would like to consider.
```sql
CREATE FUNCTION multi_treatment_matchit(
  sourceTable TEXT,             -- input table name
  primaryKey TEXT,              -- source table's primary key
  treatmentsArr TEXT[],         -- array of treatment column names
  covariatesArraysArr TEXT[][], -- array of arrays of covariates, each treatment has its own set of covariates
  outputTableBasename TEXT      -- name used in all output tables, treatment appended
) RETURNS TEXT

-- example call 
SELECT multi_treatment_matchit(
  'flights_weather_demo',
  'fid',
  ARRAY['thunder', 'lowpressure'],
  ARRAY[
    ARRAY['fog', 'hail', 'hum', 'rain', 'snow'],
    ARRAY['fog', 'hail', 'hum', 'rain', 'snow']
  ],
  'multi_treatment_matchit_flights_weather'
);
```

ZaliQL's `two_table_matchit` function is a variation of CEM matchit where the treatment variable is in table A, but covariates are spread across both table A and B. Must pass the primary/foreign key relationship between the two tables
```sql
CREATE FUNCTION two_table_matchit(
  sourceTableA TEXT,           -- input table A name
  sourceTableAPrimaryKey TEXT, -- input table A primary key
  sourceTableAForeignKey TEXT, -- foreign key linking to input table B
  covariatesArrA TEXT[],       -- covariates included in input table A
  sourceTableB TEXT,           -- input table B name
  sourceTableBPrimaryKey TEXT, -- input table B primary key
  covariatesArrB TEXT[],       -- covariates included in input table B
  treatment TEXT,              -- treatment column must be in sourceTableA
  treatmentLevels INTEGER,     -- possible levels for given treatment
  outputTable TEXT             -- output table name
) RETURNS TEXT

-- example call joining data from weather table onto flights table
SELECT two_table_matchit(
  'flights',
  'fid',
  'flightWid',
  ARRAY['airlineid', 'carrier', 'dest'],
  'weather',
  'wid',
  ARRAY['fog', 'hail', 'hum', 'rain', 'snow'],
  'carrier',
  3,
  'two_table_matchit_flights_weather'
);
```

# Analysis
## Matching Summary Statistics
ZaliQL's `matchit_summary` function returns a json object with summary statitics of the orignal table and matched materialized view.
```sql
CREATE FUNCTION matchit_summary(
  originalSourceTable TEXT,  -- original input table name
  matchedSourceTable TEXT,   -- table name that was output by matchit
  treatment TEXT,            -- treatment column name
  covariatesArr TEXT[]       -- array of covariate column names
) RETURNS JSON

-- example call
SELECT matchit_summary(
  'flights_weather_demo',
  'propensity_score_matchit_flights_weather',
  'lowpressure',
  ARRAY['fog', 'hail', 'hum', 'rain', 'snow']
);
```

## Average Treatment Effect
ZaliQL's `ate` function returns the weighted average treatment effect across the matched covariate groups of the passed treatment on the passed outcome.
```sql
CREATE FUNCTION ate(
  sourceTable TEXT,    -- input table name that was output by matchit
  outcome TEXT,        -- column name of the outcome of interest
  treatment TEXT,      -- column name of the treatment of interest
  covariatesArr TEXT[] -- array of covariate column names
) RETURNS NUMERIC

-- example call
SELECT ate(
  'propensity_score_matchit_flights_weather',
  'depdelay',
  'lowpressure',
  ARRAY['fog-matched', 'hail-matched', 'hum-matched', 'rain-matched', 'snow-matched']
);
```
