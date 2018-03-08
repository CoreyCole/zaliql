import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Observable } from 'rxjs/Observable';

// zql service
import { ApiService } from '../../../../pages/api/api.service';

@Component({
  selector: 'zql-test-api-param-columns-text-arr',
  styleUrls: ['./test-api-param-columns-text-arr.component.scss'],
  template: `
  <mat-form-field>
    <mat-select
      #selectedTable
      placeholder="column table name"
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
      placeholder="column name"
      [value]="paramData.default.columns[0]">
      <mat-option *ngFor="let column of columnNames | async" [value]="getFullColumnName(selectedTable.value, column)">
        {{ getFullColumnName(selectedTable.value, column) }}
      </mat-option>
    </mat-select>
  </mat-form-field>
  <button mat-raised-button type="button" (click)="addColumn(selectedColumn.value)">Add</button>
  <mat-chip-list class="mat-chip-list-stacked">
    <mat-chip *ngFor="let column of selectedColumns" selected="true" color="primary">
      {{ column }}
    </mat-chip>
  </mat-chip-list>
  `
})
export class TestApiParamColumnsTextArrComponent implements OnInit {
  @Input() paramData;
  @Output() columnsUpdated: EventEmitter<string[]> = new EventEmitter<string[]>();
  public tableNames: Observable<string[]>;
  public columnNames: Observable<string[]>;
  public selectedColumns: string[];

  constructor(private api: ApiService) { }

  ngOnInit() {
    this.tableNames = this.api.queryTableNames();
    this.columnNames = this.api.queryColumnNames(this.paramData.default.table);
    this.selectedColumns = this.paramData.default.columns;
    this.columnsUpdated.emit([...this.selectedColumns]);
  }

  public addColumn(fullColumnName: string) {
    if (this.selectedColumns.indexOf(fullColumnName) === -1) {
      this.selectedColumns.push(fullColumnName);
      this.columnsUpdated.emit(this.selectedColumns);
    }
  }

  public getFullColumnName(tableName: string, columnName: string): string {
    return `${tableName}.${columnName}`;
  }

  public updateColumns(selectedTable: string) {
    this.columnNames = this.api.queryColumnNames(selectedTable);
  }

}
