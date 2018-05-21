import { Component, OnInit } from '@angular/core';

import { ApiService } from '../api.service';
import { MatSelectChange } from '@angular/material';

@Component({
  selector: 'zql-json-results-viz',
  templateUrl: './json-results-viz.component.html',
  styleUrls: ['./json-results-viz.component.scss']
})
export class JsonResultsVizComponent implements OnInit {
  public data: any;
  public sampleSizeColumns = [
    { name: 'Type' },
    { name: 'All' },
    { name: 'Matched' },
    { name: 'Unmatched'}
  ];
  public sampleSizeRows: any[];
  public covariates: string[];
  public functionName: string;
  public callParams: string[];
  public callParamData: any;
  public currentCovariate: string;

  constructor(
    private api: ApiService
  ) { }

  ngOnInit() {
    console.log(JSON.stringify(this.api.resultData));
    this.data = { ...this.api.resultData.status };
    this.functionName = this.api.resultData['function_name'];
    this.callParams = Object.keys(this.api.resultData['params']);
    this.callParamData = this.api.resultData['params'];
    this.sampleSizeRows = this.parseSampleSizeRows(this.data);
    this.covariates = Object.keys(this.data['allData']['covariateStats']);
    this.currentCovariate = this.covariates[0];
  }

  public pData(param: string) {
    return this.callParamData[param];
  }

  public changeCovariate(change: MatSelectChange) {
    this.currentCovariate = change.value;
  }

  public isArray(paramData: string | string[]): boolean {
    return Array.isArray(paramData);
  }

  public parseSampleSizeRows(data): any[] {
    const rows = [];
    const allDataSizes = data['allData']['dataSizes'];
    console.log(allDataSizes);
    const matchedDataSizes = data['matchedData']['dataSizes'];
    console.log(matchedDataSizes);
    const controlRow = {
      type: 'Control',
      all: allDataSizes['controlDataSize'],
      matched: matchedDataSizes['controlDataSize'],
      unmatched: allDataSizes['controlDataSize'] - matchedDataSizes['controlDataSize']
    };
    const treatedRow = {
      type: 'Treated',
      all: allDataSizes['treatedDataSize'],
      matched: matchedDataSizes['treatedDataSize'],
      unmatched: allDataSizes['treatedDataSize'] - matchedDataSizes['treatedDataSize']
    };
    rows.push(controlRow);
    rows.push(treatedRow);
    console.log(rows);

    return rows;
  }

}
