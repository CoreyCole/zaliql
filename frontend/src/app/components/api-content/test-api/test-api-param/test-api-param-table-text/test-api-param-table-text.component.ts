import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Observable } from 'rxjs/Observable';

// zql services
import { ApiService } from '../../../../../pages/api/api.service';

@Component({
  selector: 'zql-test-api-param-table-text',
  styleUrls: ['./test-api-param-table-text.component.scss'],
  template: `
  <mat-form-field>
    <mat-select [placeholder]="paramData.description"
      #selectedTable
      [value]="paramData.default"
      (valueChange)="tableSelected.emit(selectedTable.value)">
      <mat-option *ngFor="let table of tableNames | async" [value]="table">
        {{ table }}
      </mat-option>
    </mat-select>
  </mat-form-field>
  `
})
export class TestApiParamTableTextComponent implements OnInit {
  @Input() paramData;
  @Output() tableSelected: EventEmitter<string> = new EventEmitter<string>();
  public tableNames: Observable<string[]>;

  constructor(private api: ApiService) { }

  ngOnInit() {
    this.tableNames = this.api.queryTableNames();
    this.tableSelected.emit(this.paramData.default);
  }

}
