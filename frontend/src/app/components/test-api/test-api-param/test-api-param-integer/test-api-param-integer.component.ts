import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Observable } from 'rxjs/Observable';

// zql service
import { ApiService } from '../../../../pages/api/api.service';

@Component({
  selector: 'zql-test-api-param-integer',
  styleUrls: ['./test-api-param-integer.component.scss'],
  template: `
  <mat-form-field class="full-width">
    <input matInput [placeholder]="paramData.description"
      #selectedInt
      [value]="paramData.default"
      (blur)="intSelected.emit(selectedInt.value)">
  </mat-form-field>
  `
})
export class TestApiParamIntegerComponent implements OnInit {
  @Input() paramData;
  @Output() intSelected: EventEmitter<string> = new EventEmitter<string>();
  public selectedInt: string;

  constructor() { }

  ngOnInit() {
    this.selectedInt = this.paramData.default;
    this.intSelected.emit(this.selectedInt);
  }

}
