import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import 'rxjs/add/operator/filter';
import { NavigationNode } from './models';

import { navigationNodes } from './app-routing/navigation-nodes';

@Component({
  selector: 'zql-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
  navigationNodes: NavigationNode[] = navigationNodes;

  constructor(private router: Router) { }

  ngOnInit() {
    this.router.events.subscribe(() => window.scrollTo(0, 0));
  }
}
