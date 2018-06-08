import { Component, OnChanges, Input } from '@angular/core';
import { line, curveLinear } from 'd3-shape';

@Component({
  selector: 'zql-qq-plot',
  templateUrl: './qq-plot.component.html',
  styleUrls: ['./qq-plot.component.scss']
})
export class QqPlotComponent implements OnChanges {
  @Input() data: any;
  public covariates: string[];
  public xAxis = 'treated';
  public yAxis = 'control';
  public xScaleLineUnmatched: any;
  public xScaleLineMatched: any;
  public qqxScaleLineUnmatched: any;
  public qqxScaleLineMatched: any;

  // 45 degree line
  public line45Unmatched: any;
  public line45Matched: any;
  public line45curve = curveLinear;

  // scatter plot data
  public bubbleDataUnmatched: any;
  public bubbleDataMatched: any;

  constructor() { }

  ngOnChanges() {
    console.log('qq', this.data);
    this.covariates = Object.keys(this.data);
    this.line45Unmatched = this.get45Line(this.data['originalData']);
    this.line45Matched = this.get45Line(this.data['matchedData']);
    this.bubbleDataUnmatched = this.getBubbleData(this.data['originalData']);
    this.bubbleDataUnmatched = this.getBubbleData(this.data['originalData']);
  }

  private get45Line(data: any): any[] {
    const line45 = [];
    line45.push({
      name: 'y = x',
      series: []
    });
    return line45;
  }

  private getBubbleData(data: any): any[] {
    const bubbleData = [];
    bubbleData.push({
      name: 'qq',
      series: []
    });
    return bubbleData;
  }

}
