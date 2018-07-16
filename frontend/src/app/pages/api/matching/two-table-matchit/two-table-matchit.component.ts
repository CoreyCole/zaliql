import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs/Observable';

import { FunctionData } from '../../../../models';
import { ApiService } from '../../api.service';

@Component({
  selector: 'zql-two-table-matchit',
  template: `
  <div *ngIf="functionData as data">
    <zql-api-content [functionData]="data">
      <textarea highlight-js [options]="{}" [lang]="'SQL'">
CREATE OR REPLACE FUNCTION two_table_matchit_cem(
  source_table_a TEXT,             -- input table A name
  source_table_a_primary_key TEXT, -- input table A primary key
  source_table_a_foreign_key TEXT, -- foreign key linking to input table B
  covariates_arr_a TEXT[],         -- covariates included in input table A
  source_table_b TEXT,             -- input table B name
  source_table_b_primary_key TEXT, -- input table B primary key
  covariates_arr_b TEXT[],         -- covariates included in input table B
  treatment TEXT,                  -- treatment column must be in source_table_a
  output_table TEXT                -- output table name
) RETURNS TEXT;

-- example call
SELECT two_table_matchit_cem(
  'flights_demo',
  'fid',
  'wid',
  ARRAY['dest'],
  'weather_demo',
  'wid',
  ARRAY['vism', 'hum', 'wspdm', 'thunder', 'fog', 'hail'],
  'carrierid',
  'test_flight'
);
      </textarea>
    </zql-api-content>
  </div>`
})
export class TwoTableMatchitComponent implements OnInit {
  public functionData: FunctionData;
  public functionName = 'two_table_matchit_cem';

  constructor(private api: ApiService) { }

  ngOnInit() {
    this.functionData = this.api.getFunction(this.functionName);
  }
}
