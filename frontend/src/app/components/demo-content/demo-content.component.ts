import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'zql-demo-content',
  styleUrls: ['./demo-content.component.scss'],
  template: `
  <div class="toolbar">
    <mat-toolbar class="demo-header" color="primary">
      <span *ngIf="prevUrl" class="next-nav">
        <a [routerLink]="prevUrl">
          <i class="material-icons">chevron_left</i>
          <span>{{ prevTitle }}</span>
        </a>
      </span>
      <span *ngIf="!prevUrl" class="next-nav"></span>
      <span class="flex-span"></span>
      <span>{{ title }}</span>
      <span class="flex-span"></span>
      <span *ngIf="nextUrl" class="next-nav">
        <a [routerLink]="nextUrl">
          <span>{{ nextTitle }}</span>
          <i class="material-icons">chevron_right</i>
        </a>
      </span>
      <span *ngIf="!nextUrl" class="next-nav"></span>
    </mat-toolbar>
  </div>
  <div class="ng-content">
    <ng-content></ng-content>
  </div>`
})
export class DemoContentComponent implements OnInit {
  @Input() title: string;
  @Input() prevUrl: string;
  @Input() prevTitle: string;
  @Input() nextUrl: string;
  @Input() nextTitle: string;

  ngOnInit() {
  }

}
