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
    domain: ['#675d82', '#4b2e83', '#C7B42C', '#AAAAAA']
  };
  public sampleSizeColumns = [
    { name: 'Type' },
    { name: 'All' },
    { name: 'Matched' },
    { name: 'Unmatched' }
  ];
  public sampleSizeRows: any[];

  public qqData: any;
  public currentQQCovariate: string;
  public qqCovariates: string[];
  public currentQQData: any;

  public covariates: string[];
  public functionName: string;
  public callParams: string[];
  public callParamData: any;

  // treatment charts
  public originalTreatmentData: any[];
  public matchedTreatmentData: any[];
  public treatmentData: any[];

  // covariate charts
  public weightedAverageCovariates: string[];
  public currentCovariate: string;
  public weightedAverageCovariateData: any = {};

  public covariateStatsSizeColumns = [
    { name: 'Column' },
    { name: 'Mean Control' },
    { name: 'Mean Treated' },
    { name: 'Mean Difference' },
    { name: 'Control Standard Deviation' },
    { name: 'Treated Standard Deviation' }
  ];
  public preMatchedCovariateStatsRows: any[];
  public matchedCovariateStatsRows: any[];

  constructor(
    private api: ApiService
  ) { }

  ngOnInit() {
    console.log(JSON.stringify(this.api.resultData));
    this.data = { ...this.api.resultData.status };
    this.functionName = this.api.resultData['function_name'];
    this.callParams = Object.keys(this.api.resultData['params']);
    this.callParamData = this.api.resultData['params'];
    this.qqData = this.data['qq'];
    this.sampleSizeRows = this.parseSampleSizeRows(this.data);
    this.qqCovariates = Object.keys(this.data['qq']);
    this.currentQQCovariate = this.qqCovariates[0] ? this.qqCovariates[0] : '';

    // covariate stats
    this.preMatchedCovariateStatsRows = [];
    const preMatchCovariateData = this.data['allData']['covariateStats'];
    const preMatchCovariates = Object.keys(preMatchCovariateData);
    for (const covariate of preMatchCovariates) {
      const data = preMatchCovariateData[covariate];
      this.preMatchedCovariateStatsRows.push({
        column: covariate,
        meanControl: parseFloat(data['meanControl']).toFixed(2),
        meanTreated: parseFloat(data['meanTreated']).toFixed(2),
        meanDifference: parseFloat(data['meanDiff']).toFixed(2),
        controlStandardDeviation: parseFloat(data['meanControlStdDev']).toFixed(2),
        treatedStandardDeviation: parseFloat(data['meanTreatedStdDev']).toFixed(2)
      });
    }

    this.matchedCovariateStatsRows = [];
    const matchedCovariateData = this.data['matchedData']['covariateStats'];
    const matchedCovariates = Object.keys(matchedCovariateData);
    for (const covariate of matchedCovariates) {
      const data = matchedCovariateData[covariate];
      this.matchedCovariateStatsRows.push({
        column: covariate,
        meanControl: parseFloat(data['meanControl']).toFixed(2),
        meanTreated: parseFloat(data['meanTreated']).toFixed(2),
        meanDifference: parseFloat(data['meanDiff']).toFixed(2),
        controlStandardDeviation: parseFloat(data['meanControlStdDev']).toFixed(2),
        treatedStandardDeviation: parseFloat(data['meanTreatedStdDev']).toFixed(2)
      });
    }

    // original treatment data
    const originalOutcomeControl = this.data['ate']['originalData']['avgOutcomeControl'];
    const originalOutcomeTreated = this.data['ate']['originalData']['avgOutcomeTreated'];
    this.originalTreatmentData = [
      {
        name: 'Control',
        value: originalOutcomeControl
      },
      {
        name: 'Treated',
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
        name: 'Control',
        value: matchedOutcomeControl
      },
      {
        name: 'Treated',
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
    this.weightedAverageCovariates = Object.keys(this.data['ate']['matchedData']['ordinal_covariates']);
    this.currentCovariate = this.weightedAverageCovariates[0];
    for (const covariate of this.weightedAverageCovariates) {
      this.weightedAverageCovariateData[covariate] = (
            this.data['ate']['matchedData']['ordinal_covariates'][covariate]
          ).map(data => {
        const name = data['treatment'] === 1 ? 'Treated' : 'Control';
        const value = data['weighted_avg_outcome'];
        return { name, value };
      });
    }
  }

  public pData(param: string) {
    return this.callParamData[param];
  }

  public getCovariateAvgDifference(covariateData: any[]): number {
    const controlAvg = covariateData[0].value;
    const treatedAvg = covariateData[1].value;
    return treatedAvg - controlAvg;
  }

  public getPercentBalance(covariateData: any): number {
    const value1 = covariateData[0].value; // treated
    const value2 = covariateData[1].value; // control
    const difference = Math.abs(value1 - value2);
    const avg = (value1 + value2) / 2;
    return 100 - ((difference / value1) * 100);
  }

  public changeCovariate(change: MatSelectChange) {
    this.currentCovariate = change.value;
  }

  public changeQQCovariate(change: MatSelectChange) {
    this.currentQQCovariate = change.value;
  }

  public isArray(paramData: string | string[]): boolean {
    return Array.isArray(paramData);
  }

  public parseSampleSizeRows(data): any[] {
    const rows = [];
    const allDataSizes = data['allData']['dataSizes'];
    const matchedDataSizes = data['matchedData']['dataSizes'];
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
