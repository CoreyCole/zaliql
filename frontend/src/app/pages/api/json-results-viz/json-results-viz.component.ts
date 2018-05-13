import { Component, OnInit } from '@angular/core';

import { ApiService } from '../api.service';

@Component({
  selector: 'zql-json-results-viz',
  templateUrl: './json-results-viz.component.html',
  styleUrls: ['./json-results-viz.component.scss']
})
export class JsonResultsVizComponent implements OnInit {
  public resultData: any;

  constructor(
    private api: ApiService
  ) { }

  ngOnInit() {
    console.log(this.api.resultData);
  }

}
