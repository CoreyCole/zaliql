# ZaliSQL
A SQL-Based Framework for Drawing Causal Inference from Big Data
### Table of Contents
- [Matching](https://gitlab.cs.washington.edu/bsalimi/ZaliSQL#matching)
- [Discretization](https://gitlab.cs.washington.edu/bsalimi/ZaliSQL#discretization)
- [Binning](https://gitlab.cs.washington.edu/bsalimi/ZaliSQL#binning)
- [Summary Statistics](https://gitlab.cs.washington.edu/bsalimi/ZaliSQL#summary-statistics)

# Matching
ZaliSQL's matching functions are modeled after the R packages [MatchIt]((https://cran.r-project.org/web/packages/MatchIt/MatchIt.pdf) and [CEM]((https://cran.r-project.org/web/packages/cem/cem.pdf). Matching is a pre-processing methods that makes the esstimation 
causal effect less model-dependant and biased. After preprocessing data with matching methods, researchers can use whatever parametric model they would have used without matching, but produce inferences with substantially more robustness and less sensitivity to modeling assumptions.
## MatchIt
ZaliSQL's MatchIt function uses a logistic regression function to estimate propensity score.

```
matchit(
  source_table,
  treatment
  covariates,
  method,
  method_input,
)
```
### Arguments
- source_table
  - TEXT. The name of the table containing the data to be matched.
- treatment
  - TEXT. The name of the column containing the binary treatment indicator
- covariates
  - TEXT. A comma-separated list of the covariate column names.
- output_table
  - TEXT. The name of the materialized source_table subclass where the additional columns will be appended or updated.
- method
  - TEXT, default: "nearest". The name of the desired matching method. Currently, "exact" (exact matching), "nearest" (nearest neighbor matching), and "subclass" (Subclassification) are available.
- method_input (optional)
  - TEXT, default: NULL. This optional argument specifies the optional arguments that are passed to the selected matching method.

# Discretization
## Discretize
Discretize outputs a materialized table that is a superset of the passed source_table. The additional columns represent the desired discretized covariates.
```
discretize(
  source_table,
  covariates,
  bin_function,
  bin_function_input,
  output_table
)
```
### Arguments
- source_table
  - TEXT. The name of the table containing the data to be discretized.
- covariates
  - TEXT. A comma-separated list of the covariate column names.
- bin_function
  - TEXT. The name of the desired binning function (e.g. `bin_equal_width`, `bin_equal_frequency`, or `bin_quantile`)
- bin_function_input
  - NUMERIC. The value of the binning function input variable.
- output_table
  - TEXT. The name of the materialized source_table subclass where the additional columns will be appended or updated.

# Binning
## Quantile Binning
Bin quantile splits continuous data into a prescribed number of intervals with approximately equal number of values in each interval. (e.g. 3 intervals would split the data into quartiles)
```
bin_quantile(
  source_table,
  target_column,
  output_table,
  num_intervals
)
```
### Arguments
- source_table
  - TEXT. The name of the table containing the target_column.
- target_column
  - TEXT. The name of the column containig the continuous data to be binned.
- output_table
  - TEXT. The name of the materialized source_table subclass where the binned data will be appended or updated.
- num_buckets
  - INTEGER. The number of intervals to split the continuous data into.

## Equal Width Binning
Bin equal width splits continuous data into intervals of a prescribed width.
```
bin_equal_width(
  source_table,
  target_column,
  output_table,
  width
)
```
### Arguments
- source_table
  - TEXT. The name of the table containing the target_column.
- target_column
  - TEXT. The name of the column containig the continuous data to be binned.
- output_table
  - TEXT. The name of the materialized source_table subclass where the binned data will be appended or updated.
- width
  - NUMERIC. The prescribed width to be assigned to each interval.

## Equal Frequency Binning
Bin equal frequency splits continuous data into intervals that approximately contain the same number of values.
```
bin_equal_frequency(
  source_table,
  target_column,
  output_table,
  frequency
)
```
### Arguments
- source_table
  - TEXT. The name of the table containing the target_column.
- target_column
  - TEXT. The name of the column containig the continuous data to be binned.
- output_table
  - TEXT. The name of the materialized source_table subclass where the binned data will be appended or updated.
- frequency
  - INTEGER. The approximate number of values to be contained within each bin.

# Summary Statistics
## Matching Summary
Matching summary outputs matching result statistics about the given table to standard out. This is modeled after the output of the `matchit()` function from the R package [MatchIt]((https://cran.r-project.org/web/packages/MatchIt/MatchIt.pdf)). This can only be called on a source_table that has been output by one of ZaliQL's matching functions.
```
matching_summary(
  source_table,
  covariates,
  verbose,
  output_table
)
```
### Arguments
- source_table
  - TEXT. The name of the table containing the data to be summarized.
- covariates
  - TEXT. A comma-separated list of the covariate column names.
- verbose (optional)
  - BOOLEAN, default: TRUE. Print verbose output to standard out.
- output_table (optional)
  - TEXT, default: NULL. The name of the table where the matching summary output will be stored. This table must contain the following columns (NOTE: outputs are organized into `pre` for original data, `post` for matched data, and `comp` for comparing the two data sets):
    - match_summary_id INTEGER (not unique, ties covariates to same matching method calculations)
    - table_name VARCHAR
    - covariate_name VARCHAR
    - calculated_datetime DATETIME
    - pre_means_treated NUMERIC
    - pre_means_control NUMERIC
    - pre_sd_control NUMERIC
    - pre_mean_diff NUMERIC
    - pre_eQQ_med NUMERIC
    - pre_eQQ_mean NUMERIC
    - pre_eQQ_max NUMERIC
    - post_means_treated NUMERIC
    - post_means_control NUMERIC
    - post_sd_control NUMERIC
    - post_mean_diff NUMERIC
    - post_eQQ_med NUMERIC
    - post_eQQ_mean NUMERIC
    - post_eQQ_max NUMERIC
    - comp_mean_diff NUMERIC
    - comp_eQQ_med NUMERIC
    - comp_eQQ_mean NUMERIC
    - comp_eQQ_max NUMERIC

## Statistical Summary
Statistical summary outputs generic summary statistics about the given table to standard out. This is modeled after the output of the `summary(dataframe)` function from the R standard library.
```
stat_summary(
  source_table,
  verbose,
  target_cols,
  output_table
)
```
### Arguments
- source_table
  - TEXT. The name of the table containing the data to be summarized.
- verbose (optional)
  - BOOLEAN, default: TRUE. Print verbose output to standard out.
- target_cols (optional)
  - TEXT, default: '*'. A comma-separated list of the columns to summarize. If NULL or '*', results are produced for all numeric columns.
- output_table (optional)
  - TEXT, default: NULL. The name of the table where the statistical summary output will be stored. This table must contain the following columns:
    - stat_summary_id INTEGER
    - table_name VARCHAR
    - column_name VARCHAR
    - calculated_datetime DATETIME
    - mean NUMERIC
    - median NUMERIC
    - 25th quartile NUMERIC
    - 75th quartile NUMERIC
    - min NUMERIC
    - max NUMERIC
