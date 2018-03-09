import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'zql-matchit-cem',
  styleUrls: ['./matchit-cem.component.scss'],
  template: `
  <zql-api-content [functionData]="functionData">
    <textarea highlight-js [options]="{}" [lang]="'SQL'">
CREATE OR REPLACE FUNCTION matchit_cem(
  sourceTable TEXT,     -- input table name
  primaryKey TEXT,      -- source table's primary key
  treatmentsArr TEXT[], -- array of treatment column names
  covariatesArr TEXT[], -- array of covariate column names (all covariates are applied to all treatments)
  outputTable TEXT      -- output table name
) RETURNS TEXT AS $func$

-- example call
SELECT matchit_cem(
  'flights_weather_demo',
  'fid',
  ARRAY['lowpressure'],
  ARRAY['fog', 'hail', 'hum', 'rain', 'snow'],
  'cem_matchit_flights_weather'
);
    </textarea>
  </zql-api-content>`
})
export class MatchitCemComponent implements OnInit {
  functionData = {
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
        placeholder: 'lalonde_demo',
      },
      {
        name: 'primaryKey',
        description: 'source table\'s primary key',
        type: 'column-text',
        placeholder: 'pk'
      },
      {
        name: 'treatmentsArr',
        description: 'array of treatment column names',
        type: 'columns-text-arr',
        placeholder: 'treat'
      },
      {
        name: 'covariatesArr',
        description: 'array of covariate column names. \
        (all covariates are applied to all treatments)',
        type: 'columns-text-arr',
        placeholder: 'nodegree'
      },
      {
        name: 'outputTable',
        description: '',
        type: 'text',
        placeholder: 'lalonde_demo_matched'
      }
    ]
  };
  constructor() { }

  ngOnInit() {
  }

}
