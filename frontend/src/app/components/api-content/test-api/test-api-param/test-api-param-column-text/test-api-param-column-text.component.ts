import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Observable } from 'rxjs/Observable';

// zql service
import { ApiService } from '../../../../../pages/api/api.service';

@Component({
  selector: 'zql-test-api-param-column-text',
  styleUrls: ['./test-api-param-column-text.component.scss'],
  template: `
  <mat-form-field>
    <mat-select placeholder="table name"
      #selectedTable
      [value]="paramData.default.table"
      (valueChange)="updateColumns(selectedTable.value)">
      <mat-option *ngFor="let table of tableNames | async" [value]="table">
        {{ table }}
      </mat-option>
    </mat-select>
  </mat-form-field>
  <mat-form-field>
    <mat-select
      #selectedColumn
      [placeholder]="paramData.description"
      [value]="paramData.default.column"
      (valueChange)="columnSelected.emit(selectedColumn.value)">
      <mat-option *ngFor="let column of columnNames | async" [value]="column">
        {{ column }}
      </mat-option>
    </mat-select>
  </mat-form-field>
  `
})
export class TestApiParamColumnTextComponent implements OnInit {
  @Input() paramData;
  @Output() columnSelected: EventEmitter<string> = new EventEmitter<string>();
  public tableNames: Observable<string[]>;
  public columnNames: Observable<string[]>;

  constructor(private api: ApiService) { }

  ngOnInit() {
    this.tableNames = this.api.queryTableNames();
    this.columnNames = this.api.queryColumnNames(this.paramData.default.table);
    this.columnSelected.emit(this.paramData.default.column);
  }

  public getFullColumnName(tableName: string, columnName: string): string {
    return `${tableName}.${columnName}`;
  }

  public updateColumns(selectedTable: string) {
    this.columnNames = this.api.queryColumnNames(selectedTable);
  }
}
