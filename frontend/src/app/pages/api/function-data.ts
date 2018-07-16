export const functionData = {
    'bin_equal_width': {
      'name': 'bin_equal_width',
      'category': 'preprocessing',
      'description': 'ZaliQL\'s equal width binning function. Creates a new table where the provided continuous-data columns are split into intervals of a prescribed width',
      'returns': 'TEXT function call status',
      'params': [
        {
          'name': 'source_table',
          'description': 'input table name',
          'type': 'table-text',
          'default': 'flights_weather_sfo'
        },
        {
          'name': 'target_columns',
          'description': 'array of ordinal column names to bin',
          'type': 'columns-text-arr',
          'default': {
            'table': 'flights_weather_sfo',
            'columns': ['wspdm', 'vism', 'precipm', 'tempm']
          }
        },
        {
          'name': 'num_bins_arr',
          'description': 'array of prescribed number of bins, correspond to target_columns',
          'type': 'int-arr',
          'default': [10, 15, 15, 20]
        },
        {
          'name': 'output_table',
          'description': 'output table name',
          'type': 'text',
          'default': 'flights_weather_sfo_binned'
        }
      ]
    },
    'matchit_cem': {
      'name': 'matchit_cem',
      'category': 'matching',
      'description': 'ZaliQL\'s coarsened exact matching function. Only supports 1 treatment. Treatment can be binary or have >2 levels.',
      'returns': 'TEXT function call status',
      'params': [
        {
          'name': 'source_table',
          'description': 'input table name',
          'type': 'table-text',
          'default': 'flights_weather_sfo_binned'
        },
        {
          'name': 'primary_key',
          'description': 'source table\'s primary key',
          'type': 'column-text',
          'default': {
            'table': 'flights_weather_sfo_binned',
            'column': 'fid'
          }
        },
        {
          'name': 'treatment',
          'description': 'treatment column name',
          'type': 'column-text',
          'default': {
            'table': 'flights_weather_sfo_binned',
            'column': 'lowpressure'
          }
        },
        {
          'name': 'covariates_arr',
          'description': 'array of covariate column names. (all covariates are applied to all treatments)',
          'type': 'columns-text-arr',
          'default': {
            'table': 'flights_weather_sfo_binned',
            'columns': ['wspdm_ew_binned_10', 'vism_ew_binned_15', 'precipm_ew_binned_15', 'tempm_ew_binned_20', 'fog', 'highwindspeed']
          }
        },
        {
          'name': 'output_table',
          'description': 'output table name',
          'type': 'text',
          'default': 'flights_weather_sfo_matched'
        }
      ]
    },
    'multi_treatment_matchit_cem': {
      'name': 'multi_treatment_matchit_cem',
      'category': 'matching',
      'description': 'ZaliQL\'s multi-treatment coarsened exact matching function is an optimization of `matchit_cem()` when the analyst wants to match with multiple treatment variables. Doing all the matching at once with this function is more efficient than calling `matchit_cem()` multiple times. Only supports binary treatment variables.',
      'returns': 'TEXT function call status',
      'params': [
        {
          'name': 'source_table',
          'description': 'input table name',
          'type': 'table-text',
          'default': 'flights_weather_sfo'
        },
        {
          'name': 'primary_key',
          'description': 'source table\'s primary key',
          'type': 'column-text',
          'default': {
            'table': 'flights_weather_sfo',
            'column': 'fid'
          }
        },
        {
          'name': 'treatments_arr',
          'description': 'array of treatment column names',
          'type': 'columns-text-arr',
          'default': {
            'table': 'flights_weather_sfo',
            'columns': ['lowpressure', 'lowvisibility']
          }
        },
        {
          'name': 'covariates_arrays_arr',
          'description': 'array of arrays of covariates, each treatment has its own set of covariates',
          'type': 'columns-text-arr-arr',
          'default': [
            {
              'table': 'flights_weather_sfo',
              'columns': ['wspdm', 'vism', 'precipm', 'tempm', 'fog', 'highwindspeed']
            },
            {
              'table': 'flights_weather_sfo',
              'columns': ['wspdm', 'vism', 'precipm', 'tempm', 'fog', 'highwindspeed']
            }
          ]
        },
        {
          'name': 'output_table',
          'description': 'output table name',
          'type': 'text',
          'default': 'flights_weather_sfo_matched'
        }
      ]
    },
    'two_table_matchit_cem': {
      'name': 'two_table_matchit_cem',
      'category': 'matching',
      'description': 'ZaliQL\'s `two_table_matchit` function is a variation of CEM matchit where the treatment variable is in table A, but covariates are spread across both table A and B. Must pass the primary/foreign key relationship between the two tables. Table A foreign key must have the same column name as table B primary key.',
      'returns': 'TEXT function call status',
      'params': [
        {
          'name': 'source_table_a',
          'description': 'input table A name',
          'type': 'table-text',
          'default': 'flights_sfo'
        },
        {
          'name': 'source_table_a_primary_key',
          'description': 'source table A\'s primary key',
          'type': 'column-text',
          'default': {
            'table': 'flights_sfo',
            'column': 'fid'
          }
        },
        {
          'name': 'source_table_a_foreign_key',
          'description': 'source table A\'s foreign key',
          'type': 'column-text',
          'default': {
            'table': 'flights_sfo',
            'column': 'wid'
          }
        },
        {
          'name': 'covariates_arr_a',
          'description': 'array of covariate column names in table A',
          'type': 'columns-text-arr',
          'default': {
            'table': 'flights_sfo',
            'columns': ['dest']
          }
        },
        {
          'name': 'source_table_b',
          'description': 'input table B name',
          'type': 'table-text',
          'default': 'weather_sfo'
        },
        {
          'name': 'source_table_b_primary_key',
          'description': 'source table B\'s primary key',
          'type': 'column-text',
          'default': {
            'table': 'weather_sfo',
            'column': 'wid'
          }
        },
        {
          'name': 'covariates_arr_b',
          'description': 'array of covariate column names in table B',
          'type': 'columns-text-arr',
          'default': {
            'table': 'weather_sfo',
            'columns': ['wspdm', 'vism', 'precipm', 'tempm', 'fog', 'highwindspeed']
          }
        },
        {
          'name': 'treatment',
          'description': 'treatment column name',
          'type': 'column-text',
          'default': {
            'table': 'weather_sfo',
            'column': 'lowpressure'
          }
        },
        {
          'name': 'output_table',
          'description': 'output table name',
          'type': 'text',
          'default': 'flights_weather_sfo_matched'
        }
      ]
    },
    'matchit_propensity_score': {
      'name': 'matchit_propensity_score',
      'category': 'matching',
      'description': 'ZaliQL\'s propensity score matching function. Only supports 1 treatment.',
      'returns': 'TEXT function call status',
      'params': [
        {
          'name': 'source_table',
          'description': 'input table name',
          'type': 'table-text',
          'default': 'flights_weather_sfo'
        },
        {
          'name': 'primary_key',
          'description': 'source table\'s primary key',
          'type': 'column-text',
          'default': {
            'table': 'flights_weather_sfo',
            'column': 'fid'
          }
        },
        {
          'name': 'treatment',
          'description': 'treatment column name',
          'type': 'column-text',
          'default': {
            'table': 'flights_weather_sfo',
            'column': 'lowpressure'
          }
        },
        {
          'name': 'covariates_arr',
          'description': 'array of covariate column names (all covariates are applied to all treatments)',
          'type': 'columns-text-arr',
          'default': {
            'table': 'flights_weather_sfo',
            'columns': ['wspdm', 'vism', 'precipm', 'tempm', 'fog', 'highwindspeed']
          }
        },
        {
          'name': 'k',
          'description': 'k nearest neighbors',
          'type': 'int',
          'default': '2'
        },
        {
          'name': 'caliper',
          'description': 'maximum (inclusive) propensity score distance to be considered a match',
          'type': 'numeric',
          'default': '0.1'
        },
        {
          'name': 'output_table',
          'description': 'output table name',
          'type': 'text',
          'default': 'flights_weather_sfo_matched'
        }
      ]
    },
    'matchit_cem_summary_statistics': {
      'name': 'matchit_cem_summary_statistics',
      'category': 'analysis',
      'description': 'ZaliQL\'s `matchit_cem_summary_statistics` function returns a json object with summary statitics pertaining to the orignal and matched tables',
      'returns': 'JSONB statistical summary object',
      'params': [
        {
          'name': 'original_table',
          'description': 'original input table name with binned columns',
          'type': 'table-text',
          'default': 'flights_weather_sfo_binned'
        },
        {
          'name': 'matchit_cem_table',
          'description': 'table name that was output by matchit_cem',
          'type': 'table-text',
          'default': 'flights_weather_sfo_matched'
        },
        {
          'name': 'treatment',
          'description': 'treatment column name',
          'type': 'column-text',
          'default': {
            'table': 'flights_weather_sfo_matched',
            'column': 'lowpressure'
          }
        },
        {
          'name': 'outcome',
          'description': 'outcome column name',
          'type': 'column-text',
          'default': {
            'table': 'flights_weather_sfo_matched',
            'column': 'depdel15'
          }
        },
        {
          'name': 'grouping_attribute',
          'description': 'compare ATE across specified groups (can be null)',
          'type': 'column-text-null',
          'default': {
            'table': 'null',
            'column': 'null'
          }
        },
        {
          'name': 'original_covariates_arr',
          'description': 'array of all original covariate column names (column names BEFORE discretization/binning)',
          'type': 'columns-text-arr',
          'default': {
            'table': 'flights_weather_sfo_matched',
            'columns': ['wspdm', 'vism', 'precipm', 'tempm', 'fog', 'highwindspeed']
          }
        },
        {
          'name': 'original_ordinal_covariates_arr',
          'description': 'array of original ordinal covariate column names (column names BEFORE discretization/binning)',
          'type': 'columns-text-arr',
          'default': {
            'table': 'flights_weather_sfo_matched',
            'columns': ['wspdm', 'vism', 'precipm', 'tempm']
          }
        },
        {
          'name': 'binned_ordinal_covariates_arr',
          'description': 'array of all binned ordinal covariate column names (column names AFTER discretization/binning) can be empty array if no covariates were ordinal',
          'type': 'columns-text-arr',
          'default': {
            'table': 'flights_weather_sfo_matched',
            'columns': ['wspdm_ew_binned_10', 'vism_ew_binned_15', 'precipm_ew_binned_15', 'tempm_ew_binned_20']
          }
        }
      ]
    }
  };

