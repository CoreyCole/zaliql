import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'zql-test-api-param',
  styleUrls: ['./test-api-param.component.scss'],
  template: `
  <mat-card>
    <mat-toolbar>
      <span class="flex-span"></span>
      <span>{{ paramData.name }}</span>
      <span class="flex-span"></span>
    </mat-toolbar>
    <div [ngSwitch]="paramData.type">
      <mat-card-content *ngSwitchCase="'text'">
        <zql-test-api-param-text
          [paramData]="paramData"
          (textSelected)="updateFunctionCall($event)"></zql-test-api-param-text>
      </mat-card-content>
      <mat-card-content *ngSwitchCase="'int'">
        <zql-test-api-param-text
          [paramData]="paramData"
          (textSelected)="updateFunctionCall($event)"></zql-test-api-param-text>
      </mat-card-content>
      <mat-card-content *ngSwitchCase="'numeric'">
        <zql-test-api-param-text
          [paramData]="paramData"
          (textSelected)="updateFunctionCall($event)"></zql-test-api-param-text>
      </mat-card-content>
      <mat-card-content *ngSwitchCase="'table-text'">
        <zql-test-api-param-table-text
          [paramData]="paramData"
          (tableSelected)="updateFunctionCall($event)"></zql-test-api-param-table-text>
      </mat-card-content>
      <mat-card-content *ngSwitchCase="'column-text'">
        <zql-test-api-param-column-text
          [paramData]="paramData"
          (columnSelected)="updateFunctionCall($event)"></zql-test-api-param-column-text>
      </mat-card-content>
      <mat-card-content *ngSwitchCase="'column-text-null'">
        <zql-test-api-param-column-text-null
          [paramData]="paramData"
          (columnSelected)="updateFunctionCall($event)"></zql-test-api-param-column-text-null>
      </mat-card-content>
      <mat-card-content *ngSwitchCase="'columns-text-arr'">
        <zql-test-api-param-columns-text-arr
          [paramData]="paramData"
          (columnsUpdated)="updateFunctionCall($event)"></zql-test-api-param-columns-text-arr>
      </mat-card-content>
      <mat-card-content *ngSwitchCase="'text-arr'">
        <zql-test-api-param-text-arr
          [paramData]="paramData"
          (valuesUpdated)="updateFunctionCall($event)"></zql-test-api-param-text-arr>
      </mat-card-content>
      <mat-card-content *ngSwitchCase="'int-arr'">
        <zql-test-api-param-text-arr
          [paramData]="paramData"
          (valuesUpdated)="updateFunctionCall($event)"></zql-test-api-param-text-arr>
      </mat-card-content>
      <mat-card-content *ngSwitchCase="'columns-text-arr-arr'">
        <zql-test-api-param-columns-text-arr-arr
          [paramData]="paramData"
          (columnsUpdated)="updateFunctionCall($event)"></zql-test-api-param-columns-text-arr-arr>
      </mat-card-content>
      <mat-card-content *ngSwitchDefault>
        Invalid Parameter Type!
      </mat-card-content>
    </div>
  </mat-card>
  `
})
export class TestApiParamComponent {
  @Input() paramData;
  @Output() paramUpdated: EventEmitter<string | string[] | string[][]> = new EventEmitter<string | string[]>();

  constructor() { }

  public updateFunctionCall(data: string | string[] | string[][]) {
    this.paramUpdated.emit(data);
  }
}
