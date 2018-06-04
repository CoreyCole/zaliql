import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'zql-qq-plot',
  templateUrl: './qq-plot.component.html',
  styleUrls: ['./qq-plot.component.scss']
})
export class QqPlotComponent implements OnInit {
  @Input() data: any;

  constructor() { }

  ngOnInit() {
    console.log('qq', this.data);
  }

}
