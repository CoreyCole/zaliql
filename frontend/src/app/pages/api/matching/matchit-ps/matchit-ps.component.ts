import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs/Observable';

import { FunctionData } from '../../../../models';
import { ApiService } from '../../api.service';

@Component({
  selector: 'zql-matchit-ps',
  template: `
  <div *ngIf="functionData | async as data">
    <zql-api-content [functionData]="data">
      <textarea highlight-js [options]="{}" [lang]="'SQL'">
CREATE OR REPLACE FUNCTION matchit_propensity_score(
  source_table TEXT,     -- input table name
  primary_key TEXT,      -- source table's primary key
  treatment TEXT,        -- treatment column name
  covariates_arr TEXT[], -- array of covariate column names (all covariates are applied to all treatments)
  k INTEGER,             -- k nearest neighbors
  caliper NUMERIC,       -- maximum (inclusive) propensity score distance to be considered a match
  output_table TEXT      -- output table name
) RETURNS TEXT;

-- example call
SELECT matchit_propensity_score(
  'flights_weather_demo',
  'fid',
  'lowpressure',
  ARRAY['vism', 'hum', 'wspdm', 'thunder', 'fog', 'hail'],
  2,
  0.1,
  'test_flight'
);
      </textarea>
    </zql-api-content>
  </div>`
})
export class MatchitPsComponent implements OnInit {
  public functionData: Observable<FunctionData>;
  public functionName = 'matchit_propensity_score';

  constructor(private api: ApiService) { }

  ngOnInit() {
    this.functionData = this.api.getFunction(this.functionName);
  }
}
