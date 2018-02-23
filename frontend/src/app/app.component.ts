import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
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
              url: '/api/preprocessing/bin-equal-width',
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
              url: '/api/matching/matchit',
              title: 'Matchit',
              tooltip: 'Matchit'
            },
            {
              url: '/api/matching/multi-level-treatment-matchit',
              title: 'Multi Level Treatment Matchit',
              tooltip: 'Multi Level Treatment Matchit'
            },
            {
              url: '/api/matching/multi-treatment-matchit',
              title: 'Multi Treatment Matchit',
              tooltip: 'Multi Treatment Matchit'
            },
            {
              url: '/api/matching/two-table-matchit',
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
              url: '/api/analysis/matchit-summary',
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

  constructor(private route: ActivatedRoute) { }

  ngOnInit() {
    this.route.fragment
      .filter(f => f && f.length > 0)
      .subscribe(f => {
        const element = document.querySelector('#' + f);
        if (element) {
          element.scrollIntoView(element as ScrollIntoViewOptions);
        }
      });
  }
}
