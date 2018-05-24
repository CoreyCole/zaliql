import { Component, Input, AfterViewInit } from '@angular/core';
import { Router } from '@angular/router';
import { Observable } from 'rxjs/Observable';
import { ErrorObservable } from 'rxjs/observable/ErrorObservable';
import { map, catchError } from 'rxjs/operators';

// zql imports
import { FunctionParamUpdate } from '../../models';
import { ApiService } from '../../pages/api/api.service';

@Component({
  selector: 'zql-api-content',
  styleUrls: ['./api-content.component.scss'],
  template: `
  <div class="toolbar">
    <mat-toolbar class="api-header" color="primary">
      <span class="flex-span"></span>
      <span>{{ functionData.name }}</span>
      <span class="flex-span"></span>
      <button mat-raised-button color="accent" type="button" *ngIf="!calling"
        (click)="testFunction(functionData.name, functionParamData)">Test</button>
    </mat-toolbar>
  </div>
  <div class="ng-content">
    <mat-card class="call-results" *ngIf="results || error">
      <mat-card-content>
        <span *ngIf="jsonResults">
          <zql-json-results [results]="results"></zql-json-results>
        </span>
        <span *ngIf="!jsonResults">
          {{ results }}{{ error }}
        </span>
      </mat-card-content>
    </mat-card>
    <mat-spinner color="accent" *ngIf="calling"></mat-spinner>
    <mat-card>
      <mat-card-content>
        <p>{{ functionData.description }}</p>
      </mat-card-content>
      <mat-card-content>
        <ng-content></ng-content>
      </mat-card-content>
    </mat-card>
  </div>
  <zql-test-api
    [functionData]="functionData"
    (paramUpdated)="updateFunctionParams($event)">
  </zql-test-api>
  `
})
export class ApiContentComponent implements AfterViewInit {
  @Input() functionData;
  public functionParamData: { [paramName: string]: string | string[] | string[][] } = {};
  public results$: Observable<any>;
  public results: string;
  public error: string;
  public jsonResults: boolean;
  public calling = false;

  constructor(
    private router: Router,
    private api: ApiService
  ) {}

  ngAfterViewInit() {
    this.jsonResults = this.functionData['returns'].toLowerCase().includes('json');
  }

  public updateFunctionParams(functionParamUpdate: FunctionParamUpdate) {
    this.functionParamData[functionParamUpdate.name] = functionParamUpdate.data;
    console.log(functionParamUpdate);
  }

  public testFunction(functionName: string, functionParamData: { [paramName: string]: string | string[] | string[][] }) {
    window.scrollTo(0, 0);
    this.calling = true;
    this.results$ = this.api.callFunction(functionName, functionParamData);
    this.results$.pipe(
        catchError(err => {
          console.log(err);
          this.results = '';
          this.error = err.error.status;
          this.calling = false;
          return ErrorObservable.create(err.error.status);
        })
      )
      .subscribe(data => {
        // TODO: adapt to summary stat return json
        // typeof data === 'object'
        console.log(data);
        this.error = '';
        this.results = data.status;
        this.api.setResultData(data);
        this.api.queryTableNames();
        this.calling = false;
      });
  }
}
