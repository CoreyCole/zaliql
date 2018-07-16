import { NavigationNode } from '../models';

// this is imported in app.component.ts to generate the side navigation
export const navigationNodes: NavigationNode[] = [
  {
    url: '/home',
    title: 'Home',
    tooltip: 'Home'
  },
  // {
  //   url: '/demo-home',
  //   title: 'Demo',
  //   tooltip: 'Demo',
  //   children: [
  //     {
  //       url: '/demo/causal-questions',
  //       title: 'Causal Questions',
  //       tooltip: 'Causal Questions'
  //     },
  //     {
  //       url: '/demo/naive-approach',
  //       title: 'ATE (Naive Approach)',
  //       tooltip: 'ATE (Naive Approach)'
  //     },
  //     {
  //       url: '/demo/confounding-variables',
  //       title: 'Confounding Variables',
  //       tooltip: 'Confounding Variables'
  //     },
  //     {
  //       url: '/demo/adjusting-for-covariates',
  //       title: 'Adjusting for Covariates',
  //       tooltip: 'Adjusting for Covariates'
  //     },
  //     {
  //       url: '/demo/checking-balance',
  //       title: 'Checking Balance',
  //       tooltip: 'Checking Balance'
  //     },
  //     {
  //       url: '/demo/causal-answers',
  //       title: 'Causal Answers',
  //       tooltip: 'Causal Answers'
  //     }
  //   ]
  // },
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
            url: '/api/matching/matchit_cem',
            title: 'Matchit CEM',
            tooltip: 'Matchit Coarsened Exact Matching'
          },
          {
            url: '/api/matching/multi_treatment_matchit',
            title: 'Multi Treatment Matchit CEM',
            tooltip: 'Multi Treatment Matchit'
          },
          {
            url: '/api/matching/two_table_matchit',
            title: 'Two Table Matchit CEM',
            tooltip: 'Two Table Matchit'
          },
          {
            url: '/api/matching/matchit_propensity_score',
            title: 'Matchit Propensity Score',
            tooltip: 'Matchit Propensity Score'
          }
        ]
      },
      {
        url: '/api/analysis',
        title: 'Analysis',
        tooltip: 'Analysis',
        children: [
          {
            url: '/api/analysis/matchit_cem_summary_statistics',
            title: 'Matchit CEM Summary Statistics',
            tooltip: 'Matchit CEM Summary Statistics'
          }
        ]
      }
    ]
  }
];
