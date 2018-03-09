import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import 'rxjs/add/operator/filter';
import { NavigationNode } from './models';

@Component({
  selector: 'zql-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
  navigationNodes: NavigationNode[] = [
    {
      url: '/home',
      title: 'Home',
      tooltip: 'Home'
    },
    {
      url: '/demo-home',
      title: 'Demo',
      tooltip: 'Demo',
      children: [
        {
          url: '/demo/causal-questions',
          title: 'Causal Questions',
          tooltip: 'Causal Questions'
        },
        {
          url: '/demo/naive-approach',
          title: 'ATE (Naive Approach)',
          tooltip: 'ATE (Naive Approach)'
        },
        {
          url: '/demo/confounding-variables',
          title: 'Confounding Variables',
          tooltip: 'Confounding Variables'
        },
        {
          url: '/demo/adjusting-for-covariates',
          title: 'Adjusting for Covariates',
          tooltip: 'Adjusting for Covariates'
        },
        {
          url: '/demo/checking-balance',
          title: 'Checking Balance',
          tooltip: 'Checking Balance'
        },
        {
          url: '/demo/causal-answers',
          title: 'Causal Answers',
          tooltip: 'Causal Answers'
        }
      ]
    },
    {
      url: '/api-home',
      title: 'API',
      tooltip: 'API',
      children: [
        {
          url: '/api/preprocessing',
          title: 'Preprocessing',
          tooltip: 'Preprocessing',
          children: [
            {
              url: '/api/preprocessing/bin_equal_width',
              title: 'Bin Equal Width',
              tooltip: 'Bin Equal Width'
            }
          ]
        },
        {
          url: '/api/matching',
          title: 'Matching',
          tooltip: 'Matching',
          children: [
            {
              url: '/api/matching/matchit_propensity_score',
              title: 'Matchit Propensity Score',
              tooltip: 'Matchit Propensity Score'
            },
            {
              url: '/api/matching/matchit_cem',
              title: 'Matchit CEM',
              tooltip: 'Matchit Coarsened Exact Matching'
            },
            {
              url: '/api/matching/multi_level_treatment_matchit',
              title: 'Multi Level Treatment Matchit',
              tooltip: 'Multi Level Treatment Matchit'
            },
            {
              url: '/api/matching/multi_treatment_matchit',
              title: 'Multi Treatment Matchit',
              tooltip: 'Multi Treatment Matchit'
            },
            {
              url: '/api/matching/two_table_matchit',
              title: 'Two Table Matchit',
              tooltip: 'Two Table Matchit'
            }
          ]
        },
        {
          url: '/api/analysis',
          title: 'Analysis',
          tooltip: 'Analysis',
          children: [
            {
              url: '/api/analysis/matchit_summary',
              title: 'Matchit Summary Statistics',
              tooltip: 'Matchit Summary Statistics'
            },
            {
              url: '/api/analysis/ate',
              title: 'Average Treatment Effect',
              tooltip: 'Average Treatment Effect'
            }
          ]
        }
      ]
    }
  ];

  constructor(private router: Router) { }

  ngOnInit() {
    this.router.events.subscribe(() => window.scrollTo(0, 0));
  }
}
