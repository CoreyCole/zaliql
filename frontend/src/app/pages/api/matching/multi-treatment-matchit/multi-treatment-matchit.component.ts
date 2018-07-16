import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs/Observable';

import { FunctionData } from '../../../../models';
import { ApiService } from '../../api.service';

@Component({
  selector: 'zql-multi-treatment-matchit',
  template: `
  <div *ngIf="functionData as data">
    <zql-api-content [functionData]="data">
      <textarea highlight-js [options]="{}" [lang]="'SQL'">
CREATE OR REPLACE FUNCTION multi_treatment_matchit_cem(
  source_table TEXT,              -- input table name
  primary_key TEXT,               -- source table's primary key
  treatments_arr TEXT[],          -- array of treatment column names
  covariates_arrays_arr TEXT[][], -- array of arrays of covariates, each treatment has its own set of covariates
  output_table_basename TEXT      -- name used in all output tables, treatment appended
) RETURNS TEXT;

-- example call
SELECT multi_treatment_matchit(
  'flights_weather_demo',
  'fid',
  ARRAY['lowpressure', 'rain'],
  ARRAY[
    ARRAY['fog', 'hail'],
    ARRAY['fog', 'hail']
  ],
  'test_flight'
);
      </textarea>
    </zql-api-content>
  </div>`
})
export class MultiTreatmentMatchitComponent implements OnInit {
  public functionData: FunctionData;
  public functionName = 'multi_treatment_matchit_cem';

  constructor(private api: ApiService) { }

  ngOnInit() {
    this.functionData = this.api.getFunction(this.functionName);
  }
}
