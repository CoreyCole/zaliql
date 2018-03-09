export const apiData = {
  apiUrl: 'http://localhost:5000',
  functions: {
    'bin_equal_width': {
      name: 'bin_equal_width'
    },
    'matchit_propensity_score': {
      name: 'matchit_propensity_score',
      description: 'ZaliQL\'s propensity score matching function \
      Only supports 1 treatment. \
      Coarsened exact matching supports multiple binary treatments.',
      returns: 'TEXT function call status',
      params: [
        {
          name: 'sourceTable',
          description: 'input table name',
          type: 'table-text',
          default: 'lalonde_demo',
        },
        {
          name: 'primaryKey',
          description: 'source table\'s primary key',
          type: 'column-text',
          default: {
            table: 'lalonde_demo',
            column: 'pk'
          }
        },
        {
          name: 'treatment',
          description: 'treatment column name',
          type: 'column-text',
          default: {
            table: 'lalonde_demo',
            column: 'treat'
          }
        },
        {
          name: 'covariatesArr',
          description: 'array of covariate column names. \
          (all covariates are applied to all treatments)',
          type: 'columns-text-arr',
          default: {
            table: 'lalonde_demo',
            columns: ['nodegree']
          }
        },
        {
          name: 'k',
          description: 'k nearest neighbors',
          type: 'text',
          default: '2'
        },
        {
          name: 'outputTable',
          description: 'output table name',
          type: 'text',
          default: 'lalonde_demo_matched'
        }
      ]
    },
    'matchit_cem': {
      name: 'matchit_cem'
    },
    'multi_level_treatment_matchit': {
      name: 'multi_level_treatment_matchit'
    },
    'multi_treatment_matchit': {
      name: 'multi_treatment_matchit'
    },
    'two_table_matchit': {
      name: 'two_table_matchit'
    },
    'matchit_summary': {
      name: 'matchit_summary'
    },
    'ate': {
      name: 'ate'
    }
  }
};
