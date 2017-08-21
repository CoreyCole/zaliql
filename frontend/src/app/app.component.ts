import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import 'rxjs/add/operator/filter';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  name = 'ZaliQL';
  tabLinks = [
    {label: 'Overview', link: 'home'},
    {label: 'Demo', link: 'demo'},
    {label: 'Implementation', link: 'implementation'},
    {label: 'Citations', link: 'citations'},
  ];

  constructor(private route: ActivatedRoute) { }

  ngOnInit() {
    this.route.fragment
      .filter(f => f && f.length > 0)
      .subscribe(f => {
        const element = document.querySelector('#' + f);
        if (element) {
          element.scrollIntoView(element);
        }
      });
  }
}
