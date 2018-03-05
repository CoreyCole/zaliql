import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap } from '@angular/router';
import { ApiService } from '../api.service';
import { map } from 'rxjs/operators';

@Component({
  selector: 'zql-test-api-call',
  styleUrls: ['./test-api-call.component.scss'],
  template: `
  <zql-test-api [functionData]="functionData | async"></zql-test-api>
  `
})
export class TestApiCallComponent implements OnInit {
  public functionData;

  constructor(
    private route: ActivatedRoute,
    public api: ApiService
  ) { }

  ngOnInit() {
    this.functionData = this.route.paramMap.pipe(
      map((paramMap: ParamMap) => paramMap.get('functionName')),
      map((functionName: string) => this.api.functions[functionName])
    );
  }

}
