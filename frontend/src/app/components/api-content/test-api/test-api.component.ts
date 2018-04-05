import { Component, Input, Output, EventEmitter } from '@angular/core';

// zql imports
import { FunctionParamUpdate } from '../../../models';

@Component({
  selector: 'zql-test-api',
  styleUrls: ['./test-api.component.scss'],
  template: `
  <div class="ng-content">
    <mat-card *ngIf="results || error">
      <mat-card-content>
        {{ results }}{{ error }}
      </mat-card-content>
    </mat-card>
    <form *ngIf="functionData">
      <div *ngFor="let paramData of functionData.params">
        <zql-test-api-param
          [paramData]="paramData"
          (paramUpdated)="updateFunctionParams(paramData.name, paramData.type, $event)">
        </zql-test-api-param>
      </div>
    </form>
  </div>`
})
export class TestApiComponent {
  @Input() functionData;
  @Output() paramUpdated: EventEmitter<FunctionParamUpdate> = new EventEmitter<FunctionParamUpdate>();

  constructor() {}

  public updateFunctionParams(paramName: string, paramType: string, data: string | string[] | string[][]) {
    const functionParamUpdate: FunctionParamUpdate = {
      name: paramName,
      type: paramType,
      data: data
    };
    this.paramUpdated.emit(functionParamUpdate);
  }

}
