import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs/Observable';

import { FunctionData } from '../../../../models';
import { ApiService } from '../../api.service';

@Component({
  selector: 'zql-matchit-cem-summary-statistics',
  styleUrls: ['./matchit-cem-summary-statistics.component.scss'],
  template: `
  <div *ngIf="functionData | async as data">
    <zql-api-content [functionData]="data">
      <textarea highlight-js [options]="{}" [lang]="'SQL'">
CREATE OR REPLACE FUNCTION matchit_cem_summary_statistics(
  original_table TEXT,     -- original input table name
  matchit_cem_table TEXT,  -- table name that was output by matchit
  treatment TEXT,          -- column name of the treatment of interest
  outcome TEXT,            -- column name of the outcome of interest
  grouping_attribute TEXT, -- compare ATE across specified groups (can be null)
  original_covariates_arr TEXT[],         -- array of all original covariate column names
                                          --  (column names BEFORE discretization/binning)
  original_ordinal_covariates_arr TEXT[], -- array of original ordinal covariate column names
                                          --  (column names BEFORE discretization/binning)
                                          --  can be empty array if no covariates were ordinal
  binned_ordinal_covariates_arr TEXT[]    -- array of all binned ordinal covariate column names
                                          --  (column names AFTER discretization/binning)
                                          --  can be empty array if no covariates were ordinal
) RETURNS JSONB;

-- example call
SELECT matchit_cem_summary_statistics(
  'flights_weather_demo_binned',
  'test_flight',
  'lowpressure',
  'depdel15',
  'dest',
  ARRAY['vism', 'wspdm', 'rain', 'fog'],
  ARRAY['vism', 'wspdm'],
  ARRAY['vism_ew_binned_10', 'wspdm_ew_binned_9']
);
      </textarea>
    </zql-api-content>
  </div>`
})
export class MatchitCemSummaryStatisticsComponent implements OnInit {
  public functionData: Observable<FunctionData>;
  public functionName = 'matchit_cem_summary_statistics';

  constructor(private api: ApiService) { }

  ngOnInit() {
    this.functionData = this.api.getFunction(this.functionName);
  }
}
