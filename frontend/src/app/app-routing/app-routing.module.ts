import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

// tslint:disable:max-line-length
import { HomeComponent } from '../pages/home/home.component';
import { DemoComponent } from '../pages/demo/demo.component';
import { ImplementationComponent } from '../pages/implementation/implementation.component';
import { CitationsComponent } from '../pages/citations/citations.component';
import { CausalQuestionsComponent } from '../pages/demo/causal-questions/causal-questions.component';
import { NaiveApproachComponent } from '../pages/demo/naive-approach/naive-approach.component';
import { ConfoundingVariablesComponent } from '../pages/demo/confounding-variables/confounding-variables.component';
import { AdjustingForCovariatesComponent } from '../pages/demo/adjusting-for-covariates/adjusting-for-covariates.component';
import { CheckingBalanceComponent } from '../pages/demo/checking-balance/checking-balance.component';
import { CausalAnswersComponent } from '../pages/demo/causal-answers/causal-answers.component';
import { BinEqualWidthComponent } from '../pages/api/preprocessing/bin-equal-width/bin-equal-width.component';
import { MatchitComponent } from '../pages/api/matching/matchit/matchit.component';
import { MultiLevelTreatmentMatchitComponent } from '../pages/api/matching/multi-level-treatment-matchit/multi-level-treatment-matchit.component';
import { MultiTreatmentMatchitComponent } from '../pages/api/matching/multi-treatment-matchit/multi-treatment-matchit.component';
import { TwoTableMatchitComponent } from '../pages/api/matching/two-table-matchit/two-table-matchit.component';
import { MatchitSummaryStatisticsComponent } from '../pages/api/analysis/matchit-summary-statistics/matchit-summary-statistics.component';
import { AverageTreatmentEffectComponent } from '../pages/api/analysis/average-treatment-effect/average-treatment-effect.component';
import { ApiComponent } from '../pages/api/api.component';

const routes: Routes = [
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  { path: 'home', component: HomeComponent },
  { path: 'demo-home', component: DemoComponent },
  {
    path: 'demo', children:
      [
        { path: 'causal-questions', component: CausalQuestionsComponent },
        { path: 'naive-approach', component: NaiveApproachComponent },
        { path: 'confounding-variables', component: ConfoundingVariablesComponent },
        { path: 'adjusting-for-covariates', component: AdjustingForCovariatesComponent },
        { path: 'checking-balance', component: CheckingBalanceComponent },
        { path: 'causal-answers', component: CausalAnswersComponent }
      ]
  },
  { path: 'api-home', component: ApiComponent },
  {
    path: 'api', children:
      [
        {
          path: 'preprocessing', children:
            [
              { path: 'bin-equal-width', component: BinEqualWidthComponent }
            ]
        },
        {
          path: 'matching', children:
            [
              { path: 'matchit', component: MatchitComponent },
              { path: 'multi-level-treatment-matchit', component: MultiLevelTreatmentMatchitComponent },
              { path: 'multi-treatment-matchit', component: MultiTreatmentMatchitComponent },
              { path: 'two-table-matchit', component: TwoTableMatchitComponent }
            ]
        },
        {
          path: 'analysis', children:
            [
              { path: 'matchit-summary', component: MatchitSummaryStatisticsComponent },
              { path: 'ate', component: AverageTreatmentEffectComponent }
            ]
        }
      ]
  },
  { path: 'implementation', component: ImplementationComponent },
  { path: 'citations', component: CitationsComponent }
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes)
  ],
  exports: [
    RouterModule
  ],
  declarations: []
})
export class AppRoutingModule { }
