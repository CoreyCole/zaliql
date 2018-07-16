import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'zql-api',
  styleUrls: ['./api.component.scss'],
  template: `
  <mat-card>
    <mat-toolbar color="accent">
      <span>ZaliQL's API</span>
    </mat-toolbar>
    <p>
      ZaliQL's API can easily be installed on any local machine leveraging the portability of docker.
      Databases running inside docker do not scale to large datasets. To get maximum
      scalability out of ZaliQL, one should install our dependencies (MADlib)
      and our custom plpgsql functions into a standalone database. The docker configuration is simply
      for ease of demonstration with smaller datasets.
    </p>
  </mat-card>
  <router-outlet></router-outlet>
  `
})
export class ApiComponent implements OnInit {

  constructor() { }

  ngOnInit() {
  }

}
