import { Component, Input } from '@angular/core';
import { NavigationNode } from '../../models';

@Component({
  selector: 'zql-nav-menu',
  template: `
  <zql-nav-item *ngFor="let node of filteredNodes" [node]="node">
  </zql-nav-item>`
})
export class NavMenuComponent {
  @Input() nodes: NavigationNode[];
  get filteredNodes() { return this.nodes ? this.nodes.filter(n => !n.hidden) : []; }
}
