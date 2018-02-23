import { Component, Input, OnChanges } from '@angular/core';
import { NavigationNode } from '../../models';

@Component({
  selector: 'zql-nav-item',
  templateUrl: './nav-item.component.html',
  styleUrls: ['./nav-item.component.scss']
})
export class NavItemComponent implements OnChanges {
  @Input() level = 1;
  @Input() node: NavigationNode;

  classes: {[index: string]: boolean };
  nodeChildren: NavigationNode[];

  ngOnChanges() {
    this.nodeChildren = this.node && this.node.children ? this.node.children.filter(n => !n.hidden) : [];
    this.classes = {
      ['level-' + this.level]: true
    };
  }
}
