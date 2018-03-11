import { Component, OnInit, Input } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { ErrorObservable } from 'rxjs/observable/ErrorObservable';
import { map, catchError } from 'rxjs/operators';

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
    <mat-card *ngIf="results || error">
      <mat-card-content>
        {{ results }}{{ error }}
      </mat-card-content>
    </mat-card>
    <form>
      <div *ngFor="let paramData of functionData.params">
        <zql-test-api-param
          [paramData]="paramData"
          (paramUpdated)="updateFunctionParams(paramData.name, paramData.type, $event)"></zql-test-api-param>
      </div>
    </form>
  </div>`
})
export class TestApiComponent implements OnInit {
  @Input() functionData;
  public functionParamData: { [paramName: string]: string | string[] } = {};
  public results$: Observable<any>;
  public results: string;
  public error: string;

  constructor(private api: ApiService) { }

  ngOnInit() {
  }

  public updateFunctionParams(paramName: string, paramType: string, data: string | string[]) {
    this.functionParamData[paramName] = data;
    console.log(this.functionParamData);
  }

  public testFunction(functionName: string, functionParamData: { [paramName: string]: string | string[] }) {
    this.results$ = this.api.callFunction(functionName, functionParamData);
    this.results$.pipe(
        map(data => data.status),
        catchError(err => {
          console.log(err);
          this.results = '';
          this.error = err.error.status;
          return ErrorObservable.create(err.error.status);
        })
      )
      .subscribe(data => {
        console.log(data);
        this.error = '';
        this.results = data;
        this.api.queryTableNames();
      });
  }

}
