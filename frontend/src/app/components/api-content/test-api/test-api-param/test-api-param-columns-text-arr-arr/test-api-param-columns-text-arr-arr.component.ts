import { Component, OnInit, Input, Output, EventEmitter, ChangeDetectorRef } from '@angular/core';
import { Observable } from 'rxjs/Observable';

// zql service
import { ApiService } from '../../../../../pages/api/api.service';

@Component({
  selector: 'zql-test-api-param-columns-text-arr-arr',
  styleUrls: ['./test-api-param-columns-text-arr-arr.component.scss'],
  template: `
  <mat-form-field>
    <mat-select
      #selectedTable
      placeholder="column table name"
      [value]="paramData.default[0].table"
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
      [value]="paramData.default[0].columns[0]">
      <mat-option *ngFor="let column of columnNames | async" [value]="column">
        {{ column }}
      </mat-option>
    </mat-select>
  </mat-form-field>
  <mat-form-field>
    <mat-select
      #selectedArr
      placeholder="array index"
      [value]="0">
      <mat-option *ngFor="let columnsArr of selectedColumns; index as i" [value]="i">
        {{ i }}
      </mat-option>
      <mat-option [value]="selectedColumns.length">
        {{ selectedColumns.length }} (create new columns array)
      </mat-option>
    </mat-select>
  </mat-form-field>
  <button mat-raised-button type="button" (click)="addColumn(selectedColumn.value, selectedArr.value)">Add</button>
  <div *ngFor="let columnsArr of selectedColumns; index as i">
    {{ i }} )
    <mat-chip-list>
      <mat-chip *ngFor="let column of columnsArr"
        selected="true"
        (click)="removeColumn(column, i)">
          {{ column }}
      </mat-chip>
    </mat-chip-list>
  </div>
  `
})
export class TestApiParamColumnsTextArrArrComponent implements OnInit {
  @Input() paramData;
  @Output() columnsUpdated: EventEmitter<string[][]> = new EventEmitter<string[][]>();
  public tableNames: Observable<string[]>;
  public columnNames: Observable<string[]>;
  public selectedColumns: string[][];

  constructor(
    private cdf: ChangeDetectorRef, // need ChangeDetectorRef to update the ngFor with the new "Create New" index
    private api: ApiService
  ) { }

  ngOnInit() {
    this.tableNames = this.api.queryTableNames();
    this.columnNames = this.api.queryColumnNames(this.paramData.default[0].table);
    this.selectedColumns = new Array<string[]>(this.paramData.default.length);
    for (let i = 0; i < this.paramData.default.length; i++) {
      this.selectedColumns[i] = this.paramData.default[i].columns.slice(); // slice for copy
    }
    this.columnsUpdated.emit(this.selectedColumns);
  }

  public addColumn(columnName: string, arrayIndex: number) {
    if (arrayIndex === this.selectedColumns.length) {
      const newSelectedColumns = this.selectedColumns.slice();
      newSelectedColumns.push(new Array<string>());
      newSelectedColumns[arrayIndex].push(columnName);
      this.selectedColumns = newSelectedColumns.slice();
      this.cdf.detectChanges();
    } else if (this.selectedColumns[arrayIndex].indexOf(columnName) === -1) {
      this.selectedColumns[arrayIndex].push(columnName);
    }
    this.columnsUpdated.emit(this.selectedColumns);
  }

  public removeColumn(columnName: string, arrayIndex: number) {
    if (arrayIndex < this.selectedColumns.length) {
      const index = this.selectedColumns[arrayIndex].indexOf(columnName);
      const thisColumnList = this.selectedColumns[arrayIndex];

      // check to make sure the columnName is in this list of column names
      if (index > -1) {
        thisColumnList.splice(index, 1);
      }

      // check if this list of column names is now empty (removed last column name)
      if (thisColumnList.length === 0) {
        // remove this list of column names from the aggregate selected columns list
        this.selectedColumns.splice(arrayIndex, 1);
        this.cdf.detectChanges();
      } else {
        // we removed 1 column name and this list of column names is not empty
        // update selected columns with this column list
        this.selectedColumns[arrayIndex] = thisColumnList;
      }

      this.columnsUpdated.emit(this.selectedColumns);
    }
  }

  public updateColumns(selectedTable: string) {
    this.columnNames = this.api.queryColumnNames(selectedTable);
  }
}
