import { Component, OnInit, Input } from '@angular/core';
import { Router } from '@angular/router';

import { ApiService } from '../../../pages/api/api.service';

@Component({
  selector: 'zql-json-results',
  styleUrls: ['./json-results.component.scss'],
  template: `
    <div class="flex-row-container">
      <span>Click to view the visualized results of this function</span>
      <span class="flex-span"></span>
      <button mat-raised-button color="primary" (click)="viewResults()">VIEW</button>
    </div>
  `
})
export class JsonResultsComponent implements OnInit {
  @Input() results;

  constructor(
    private router: Router,
    private api: ApiService
  ) { }

  ngOnInit() {
  }

  public viewResults() {
    this.api.setResultData(this.results);
    this.router.navigateByUrl('api/json-results-viz');
  }

}
