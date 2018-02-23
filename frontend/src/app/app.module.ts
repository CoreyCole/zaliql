import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

// angular router
import { AppRoutingModule } from './app-routing/app-routing.module';

// angular material dependencies
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import 'hammerjs';

// angular material components
import {
  MatButtonModule,
  MatCheckboxModule,
  MatToolbarModule,
  MatGridListModule,
  MatTabsModule,
  MatCardModule,
  MatListModule,
  MatSlideToggleModule,
  MatSidenav,
  MatSidenavModule
} from '@angular/material';
// material icons
import { MatIconModule, MatIconRegistry } from '@angular/material/icon';


// ngx charts
import {
  BarChartModule
} from '@swimlane/ngx-charts';

// ngx datatable
import { NgxDatatableModule } from '@swimlane/ngx-datatable';

// highlightJS
import { HighlightJsModule, HighlightJsService } from 'angular2-highlight-js';

// tslint:disable:max-line-length
import { AppComponent } from './app.component';
import { HomeComponent } from './pages/home/home.component';
import { DemoComponent } from './pages/demo/demo.component';
import { ImplementationComponent } from './pages/implementation/implementation.component';
import { CitationsComponent } from './pages/citations/citations.component';
import { GroupedVerticalBarChartComponent } from './pages/demo/grouped-vertical-bar-chart/grouped-vertical-bar-chart.component';
import { NavItemComponent } from './components/nav-item/nav-item.component';
import { NavMenuComponent } from './components/nav-menu/nav-menu.component';
import { DemoContentComponent } from './components/demo-content/demo-content.component';
import { ApiContentComponent } from './components/api-content/api-content.component';
import { ApiComponent } from './pages/api/api.component';
import { BinEqualWidthComponent } from './pages/api/preprocessing/bin-equal-width/bin-equal-width.component';
import { MatchitComponent } from './pages/api/matching/matchit/matchit.component';
import { MultiLevelTreatmentMatchitComponent } from './pages/api/matching/multi-level-treatment-matchit/multi-level-treatment-matchit.component';
import { MultiTreatmentMatchitComponent } from './pages/api/matching/multi-treatment-matchit/multi-treatment-matchit.component';
import { TwoTableMatchitComponent } from './pages/api/matching/two-table-matchit/two-table-matchit.component';
import { MatchitSummaryStatisticsComponent } from './pages/api/analysis/matchit-summary-statistics/matchit-summary-statistics.component';
import { AverageTreatmentEffectComponent } from './pages/api/analysis/average-treatment-effect/average-treatment-effect.component';
import { CausalQuestionsComponent } from './pages/demo/causal-questions/causal-questions.component';
import { NaiveApproachComponent } from './pages/demo/naive-approach/naive-approach.component';
import { ConfoundingVariablesComponent } from './pages/demo/confounding-variables/confounding-variables.component';
import { AdjustingForCovariatesComponent } from './pages/demo/adjusting-for-covariates/adjusting-for-covariates.component';
import { CheckingBalanceComponent } from './pages/demo/checking-balance/checking-balance.component';
import { CausalAnswersComponent } from './pages/demo/causal-answers/causal-answers.component';

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    DemoComponent,
    ImplementationComponent,
    CitationsComponent,
    GroupedVerticalBarChartComponent,
    NavItemComponent,
    NavMenuComponent,
    DemoContentComponent,
    ApiContentComponent,
    ApiComponent,
    BinEqualWidthComponent,
    MatchitComponent,
    MultiLevelTreatmentMatchitComponent,
    MultiTreatmentMatchitComponent,
    TwoTableMatchitComponent,
    MatchitSummaryStatisticsComponent,
    AverageTreatmentEffectComponent,
    CausalQuestionsComponent,
    NaiveApproachComponent,
    ConfoundingVariablesComponent,
    AdjustingForCovariatesComponent,
    CheckingBalanceComponent,
    CausalAnswersComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    // angular material components
    MatButtonModule,
    MatCheckboxModule,
    MatToolbarModule,
    MatGridListModule,
    MatTabsModule,
    MatCardModule,
    MatListModule,
    MatSlideToggleModule,
    MatSidenavModule,
    // material icons
    MatIconModule,
    // ngx charts components
    BarChartModule,
    // ngx datatable
    NgxDatatableModule,
    // highlightJS
    HighlightJsModule
  ],
  providers: [
    // material icons
    MatIconRegistry,
    // highlightJS
    HighlightJsService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
