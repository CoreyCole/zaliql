import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'zql-matchit-ps',
  styleUrls: ['./matchit-ps.component.scss'],
  template: `
  <zql-api-content [functionData]="functionData">
    <textarea highlight-js [options]="{}" [lang]="'SQL'">
CREATE OR REPLACE FUNCTION matchit_propensity_score(
  sourceTable TEXT,     -- input table name
  primaryKey TEXT,      -- source table's primary key
  treatment TEXT,       -- treatment column name
  covariatesArr TEXT[], -- array of covariate column names (all covariates are applied to all treatments)
  k INTEGER,            -- k nearest neighbors
  outputTable TEXT      -- output table name
) RETURNS TEXT AS $func$

-- example call
matchit_propensity_score(
  'flights_weather_demo',
  'fid',
  'lowpressure',
  ARRAY['fog', 'hail', 'hum', 'rain', 'snow'],
  2,
  'propensity_score_matchit_flights_weather'
)
    </textarea>
  </zql-api-content>`
})
export class MatchitPsComponent implements OnInit {
  functionData = {
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
        placeholder: 'lalonde_demo',
      },
      {
        name: 'primaryKey',
        description: 'source table\'s primary key',
        type: 'column-text',
        placeholder: 'pk'
      },
      {
        name: 'treatment',
        description: 'array of treatment column names',
        type: 'column-text',
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
        name: 'method',
        description: 'output table name',
        type: 'text',
        placeholder: 'ps'
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
