import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'zql-test-api-param-text',
  styleUrls: ['./test-api-param-text.component.scss'],
  template: `
  <mat-form-field class="full-width">
    <input matInput [placeholder]="paramData.description"
      #input
      [value]="paramData.default"
      (blur)="textSelected.emit(input.value)">
  </mat-form-field>
  `
})
export class TestApiParamTextComponent implements OnInit {
  @Input() paramData;
  @Output() textSelected: EventEmitter<string> = new EventEmitter<string>();
  public selectedText: string;

  constructor() { }

  ngOnInit() {
    this.selectedText = this.paramData.default;
    this.textSelected.emit(this.selectedText);
  }

}
