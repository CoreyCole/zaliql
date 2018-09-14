import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'zql-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {

  public authors = [
    {
      name: 'Corey Cole',
      email: 'coreylc@uw.edu'
    },
    {
      name: 'Babak Salimi',
      email: 'bsalimi@cs.washington.edu'
    },
    {
      name: 'Dan Suciu',
      email: 'suciu@cs.washington.edu'
    },
    {
      name: 'Dan R. K. Ports',
      email: 'drkp@cs.washington.edu'
    }
  ];

  constructor() { }

  ngOnInit() {
  }

  mailTo(email: string) {
    window.location.href = `mailto:${email}`;
  }

}
