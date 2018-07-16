import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs/Observable';

import { FunctionData } from '../../../../models';
import { ApiService } from '../../api.service';

@Component({
  selector: 'zql-matchit-cem',
  template: `
  <div *ngIf="functionData as data">
    <zql-api-content [functionData]="data">
      <textarea highlight-js [options]="{}" [lang]="'SQL'">
CREATE OR REPLACE FUNCTION matchit_cem(
  source_table TEXT,     -- input table name
  primary_key TEXT,      -- source table's primary key
  treatment TEXT,        -- array of treatment column names
  covariates_arr TEXT[], -- array of covariate column names (all covariates are applied to all treatments)
  output_table TEXT      -- output table name
) RETURNS TEXT;

-- example call
-- NOTE: must bin vism and wspdm for this call to work
SELECT matchit_cem(
  'flights_weather_demo_binned',
  'fid',
  'lowpressure',
  ARRAY['vism_ew_binned_10', 'wspdm_ew_binned_9', 'hour', 'rain', 'fog'],
  'test_flight'
);
      </textarea>
    </zql-api-content>
  </div>`
})
export class MatchitCemComponent implements OnInit {
  public functionData: FunctionData;
  public functionName = 'matchit_cem';

  constructor(private api: ApiService) { }

  ngOnInit() {
    this.functionData = this.api.getFunction(this.functionName);
  }
}
