import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'zql-demo-content',
  templateUrl: './demo-content.component.html',
  styleUrls: ['./demo-content.component.scss']
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
