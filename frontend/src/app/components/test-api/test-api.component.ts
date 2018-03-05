import { Component, OnInit, Input } from '@angular/core';
import { Observable } from 'rxjs/Observable';

// zql service
import { ApiService } from '../../pages/api/api.service';

@Component({
  selector: 'zql-test-api',
  styleUrls: ['./test-api.component.scss'],
  template: `
  <div class="toolbar">
    <mat-toolbar class="api-header" color="primary">
      <span class="flex-span"></span>
      <span>{{ functionData.name }}</span>
      <span class="flex-span"></span>
      <button mat-raised-button color="accent" type="button"
        (click)="testFunction(functionData.name, functionParamData)">Test</button>
    </mat-toolbar>
  </div>
  <div class="ng-content">
    <div *ngIf="(results$ | async) as results">{{ results }}</div>
    <form>
      <div *ngFor="let paramData of functionData.params">
        <zql-test-api-param
          [paramData]="paramData"
          (paramUpdated)="updateFunctionParams(paramData.name, $event)"></zql-test-api-param>
      </div>
    </form>
  </div>`
})
export class TestApiComponent implements OnInit {
  @Input() functionData;
  public functionParamData: { [paramName: string]: string | string[] } = {};
  public results$: Observable<any>;

  constructor(private api: ApiService) { }

  ngOnInit() {
    window.scrollTo(0, 0);
  }

  public updateFunctionParams(paramName: string, data: string | string[]) {
    this.functionParamData[paramName] = data;
    console.log(this.functionParamData);
  }

  public testFunction(functionName: string, functionParamData: { [paramName: string]: string | string[] }) {
    this.results$ = this.api.callFunction(functionName, functionParamData);
    this.results$.subscribe(data => console.log(data));
  }

}
