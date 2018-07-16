import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs/Observable';

import { FunctionData } from '../../../../models';
import { ApiService } from '../../api.service';

@Component({
  selector: 'zql-bin-equal-width',
  template: `
  <div *ngIf="functionData as data">
    <zql-api-content [functionData]="data">
      <textarea highlight-js [options]="{}" [lang]="'SQL'">
CREATE OR REPLACE FUNCTION bin_equal_width(
  source_table TEXT,          -- input table name
  target_columns_arr TEXT[],  -- array of ordinal column names to bin
  num_bins_arr INTEGER[],     -- array of prescribed number of bins, correspond to target_columns
  output_table TEXT           -- output table name
) RETURNS TEXT;

-- example call
SELECT bin_equal_width(
  'flights_weather_demo',
  ARRAY['vism', 'wspdm'],
  ARRAY[10, 9],
  'flights_weather_demo_binned'
);
      </textarea>
    </zql-api-content>
  </div>`
})
export class BinEqualWidthComponent implements OnInit {
  public functionData: FunctionData;
  public functionName = 'bin_equal_width';

  constructor(private api: ApiService) { }

  ngOnInit() {
    this.functionData = this.api.getFunction(this.functionName);
  }

}
