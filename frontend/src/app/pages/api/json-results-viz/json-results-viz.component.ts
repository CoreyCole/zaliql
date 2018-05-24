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
  public view: any[] = [900, 400];
  public colorScheme = {
    domain: ['#5AA454', '#A10A28', '#C7B42C', '#AAAAAA']
  };
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

  // treatment charts
  public originalTreatmentData: any[];
  public matchedTreatmentData: any[];
  public treatmentData: any[];

  // covariate charts
  public binaryCovariates: string[];
  public currentCovariate: string;
  public covariateATE: any = {};

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

    // original treatment data
    const originalOutcomeControl = this.data['ate']['originalData']['avgOutcomeControl'];
    const originalOutcomeTreated = this.data['ate']['originalData']['avgOutcomeTreated'];
    this.originalTreatmentData = [
      {
        name: `${this.pData('treatment')} false`,
        value: originalOutcomeControl
      },
      {
        name: `${this.pData('treatment')} true`,
        value: originalOutcomeTreated
      }
    ];

    // matched treatment data
    let matchedOutcomeControl;
    let matchedOutcomeTreated;
    for (const element of this.data['ate']['matchedData']['treatment']) {
      if (element['treatment'] === 1) {
        matchedOutcomeTreated = element['weighted_avg_outcome'];
      } else {
        matchedOutcomeControl = element['weighted_avg_outcome'];
      }
    }
    this.matchedTreatmentData = [
      {
        name: `${this.pData('treatment')} false`,
        value: matchedOutcomeControl
      },
      {
        name: `${this.pData('treatment')} true`,
        value: matchedOutcomeTreated
      }
    ];

    this.treatmentData = [
      {
        name: 'Original Data',
        series: this.originalTreatmentData
      },
      {
        name: 'Matched Data',
        series: this.matchedTreatmentData
      }
    ];

    // chart data for covariates
    this.binaryCovariates = Object.keys(this.data['ate']['matchedData']['binary_covariates']);
    for (const covariate of this.binaryCovariates) {
      this.covariateATE[covariate] = this.data['ate']['matchedData']['binary_covariates'][covariate].map(data => {
        const name = data['treatment'] === 1 ? `${covariate} true` : `${covariate} false`;
        const value = data['weighted_avg_outcome'];
        return { name, value };
      }).reverse();
    }
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
