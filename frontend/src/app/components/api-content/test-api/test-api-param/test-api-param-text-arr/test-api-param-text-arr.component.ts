import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'zql-test-api-param-text-arr',
  styleUrls: ['./test-api-param-text-arr.component.scss'],
  template: `
  <mat-form-field>
    <input matInput
      placeholder="value"
      #selectedText
      [value]="paramData.default[0]">
  </mat-form-field>
  <button mat-raised-button type="button" (click)="addValue(selectedText.value)">Add</button>
  <mat-chip-list>
    <mat-chip *ngFor="let value of values"
      selected="true"
      (click)="removeValue(value)">
        {{ value }}
    </mat-chip>
  </mat-chip-list>
  `
})
export class TestApiParamTextArrComponent implements OnInit {
  @Input() paramData;
  @Output() valuesUpdated: EventEmitter<string[]> = new EventEmitter<string[]>();
  public values: string[];

  constructor() { }

  ngOnInit() {
    this.values = this.paramData.default.slice(); // slice for copy
    this.valuesUpdated.emit(this.values);
  }

  public addValue(value: string) {
    if (this.values.indexOf(value) === -1) {
      this.values.push(value);
      this.valuesUpdated.emit(this.values);
    }
  }

  public removeValue(value: string) {
    const index = this.values.indexOf(value);
    if (index > -1) {
      this.values.splice(index, 1);
      this.valuesUpdated.emit(this.values);
    }
  }
}
