import { Component, OnInit } from '@angular/core';
import { simpleQueryAnswers, simpsonsParadox, effectQuery1, effectQuery2 } from './chart-data';
import { schemaColumns, schemaRows, biasColumns, biasRows } from './datatable-data';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';

@Component({
  selector: 'zql-grouped-vertical-bar-chart',
  templateUrl: './grouped-vertical-bar-chart.component.html',
  styleUrls: ['./grouped-vertical-bar-chart.component.scss']
})
export class GroupedVerticalBarChartComponent implements OnInit {

  // charts
  public simpleQueryAnswers: any = { data: [] };
  public simpsonsParadox: any = { data: [] };
  public effectQuery1: any = { data: [] };
  public effectQuery2: any = { data: [] };
  public view: any[] = [900, 400];
  public groupByCarrier = true;
  public colorScheme = {
    domain: ['#5AA454', '#A10A28', '#C7B42C', '#AAAAAA']
  };

  // data tables
  public schemaColumns: any[];
  public schemaRows: any[];
  public biasColumns: any[];
  public biasRows: any[];

  public sampleContent = `
  <pre>
    <code class="SQL highlight">
      SELECT avg(Delayed)
      FROM FlightData
      GROUP BY Carrier
      WHERE Carrier IN ('AA, 'UA')
        AND Airport IN ('COS', 'MFE', 'MTJ', 'ROC');
    </code>
  </pre>
  `;

  constructor() {
    Object.assign(this, { simpleQueryAnswers, simpsonsParadox, effectQuery1, effectQuery2 });
    Object.assign(this, { schemaColumns, schemaRows, biasColumns, biasRows });
  }

  ngOnInit() {
  }

}
