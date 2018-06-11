import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'zql-causal-questions',
  templateUrl: './causal-questions.component.html',
  styleUrls: ['./causal-questions.component.scss']
})
export class CausalQuestionsComponent implements OnInit {
  // chart config
  public view: any[] = [700, 400];
  public colorScheme = {
    domain: ['#5AA454', '#A10A28', '#C7B42C', '#AAAAAA']
  };

  // original data
  public preAvgControl = 0.4668512312399825;
  public preAvgTreated = 0.5762831858407079;
  public preDiff = this.preAvgTreated - this.preAvgControl;
  public preMatchedAverages = [
    {
      name: 'Control',
      value: this.preAvgControl
    },
    {
      name: 'Treated',
      value: this.preAvgTreated
    }
  ];

  // matched data
  public matchedAvgControl = 0.6125077987146953;
  public matchedAvgTreated = 0.6264216278001825;
  public matchedDiff = this.matchedAvgTreated - this.matchedAvgControl;
  public matchedAverages = [
    {
      name: 'Control',
      value: this.matchedAvgControl
    },
    {
      name: 'Treated',
      value: this.matchedAvgTreated
    }
  ];


  constructor() { }

  ngOnInit() {
  }

}
