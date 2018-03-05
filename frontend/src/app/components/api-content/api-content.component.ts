import { Component, Input } from '@angular/core';
import { Router } from '@angular/router';

// zql imports
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
    </mat-toolbar>
  </div>
  <div class="ng-content">
    <mat-card>
      <mat-card-content>
        <p>{{ functionData.description }}</p>
      </mat-card-content>
      <mat-card-content>
        <ng-content></ng-content>
      </mat-card-content>
      <mat-card-actions align="end">
        <button mat-raised-button color="accent" (click)="testFunction(functionData)">Test</button>
      </mat-card-actions>
    </mat-card>
  </div>`
})
export class ApiContentComponent {
  @Input() functionData;

  constructor(
    private router: Router,
    private api: ApiService
  ) {}

  public testFunction(functionData): void {
    this.router.navigate(['test-api', this.functionData.name]);
  }
}
