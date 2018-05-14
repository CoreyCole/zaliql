import { Component, OnInit } from '@angular/core';

import { ApiService } from '../api.service';

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

  constructor(
    private api: ApiService
  ) { }

  ngOnInit() {
    console.log(JSON.stringify(this.api.resultData));
    this.data = { ...this.api.resultData };
    this.sampleSizeRows = this.parseSampleSizeRows(this.data);
    this.covariates = Object.keys(this.data['allData']['covariateStats']);
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
