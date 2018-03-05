export const apiData = {
  apiUrl: 'http://localhost:5000',
  functions: {
    'bin_equal_width': {
      name: 'bin_equal_width'
    },
    'matchit': {
      name: 'matchit',
      description: 'ZaliQL\'s `matchit` function currently supports 2 matching methods: \
      `cem` (coarsened exact matching) and \
      `ps` (propensity score matching). \
      Propensity score matching only supports 1 treatment. \
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
          name: 'treatmentsArr',
          description: 'array of treatment column names',
          type: 'columns-text-arr',
          default: {
            table: 'lalonde_demo',
            columns: ['lalonde_demo.treat']
          }
        },
        {
          name: 'covariatesArr',
          description: 'array of covariate column names. \
          (all covariates are applied to all treatments)',
          type: 'columns-text-arr',
          default: {
            table: 'lalonde_demo',
            columns: ['lalonde_demo.nodegree', 'lalonde_demo.black']
          }
        },
        {
          name: 'method',
          description: 'matchit method name (`cem` or `ps`)',
          type: 'text',
          default: 'ps'
        },
        {
          name: 'outputTable',
          description: 'output table name',
          type: 'text',
          default: 'lalonde_demo_matched'
        }
      ]
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
