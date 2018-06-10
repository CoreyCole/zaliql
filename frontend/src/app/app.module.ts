import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';

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
  MatSidenavModule,
  MatInputModule,
  MatSelectModule,
  MatChipsModule,
  MatProgressSpinnerModule
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
import { HighlightJsModule } from 'ngx-highlight-js';

// tslint:disable:max-line-length
// root app component
import { AppComponent } from './app.component';

// zql pages
import { HomeComponent } from './pages/home/home.component';
import { DemoComponent } from './pages/demo/demo.component';
import { ImplementationComponent } from './pages/implementation/implementation.component';
import { CitationsComponent } from './pages/citations/citations.component';
import { GroupedVerticalBarChartComponent } from './components/grouped-vertical-bar-chart/grouped-vertical-bar-chart.component';

// zql api pages
import { ApiComponent } from './pages/api/api.component';
import { BinEqualWidthComponent } from './pages/api/preprocessing/bin-equal-width/bin-equal-width.component';
import { MatchitCemComponent } from './pages/api/matching/matchit-cem/matchit-cem.component';
import { MatchitPsComponent } from './pages/api/matching/matchit-ps/matchit-ps.component';
import { MultiTreatmentMatchitComponent } from './pages/api/matching/multi-treatment-matchit/multi-treatment-matchit.component';
import { TwoTableMatchitComponent } from './pages/api/matching/two-table-matchit/two-table-matchit.component';
import { MatchitCemSummaryStatisticsComponent } from './pages/api/analysis/matchit-cem-summary-statistics/matchit-cem-summary-statistics.component';

// zql demo pages
import { CausalQuestionsComponent } from './pages/demo/causal-questions/causal-questions.component';
import { NaiveApproachComponent } from './pages/demo/naive-approach/naive-approach.component';
import { ConfoundingVariablesComponent } from './pages/demo/confounding-variables/confounding-variables.component';
import { AdjustingForCovariatesComponent } from './pages/demo/adjusting-for-covariates/adjusting-for-covariates.component';
import { CheckingBalanceComponent } from './pages/demo/checking-balance/checking-balance.component';
import { CausalAnswersComponent } from './pages/demo/causal-answers/causal-answers.component';

// zql components
import { NavItemComponent } from './components/nav-item/nav-item.component';
import { NavMenuComponent } from './components/nav-menu/nav-menu.component';
import { DemoContentComponent } from './components/demo-content/demo-content.component';

// zql api components
import { ApiContentComponent } from './components/api-content/api-content.component';
import { TestApiComponent } from './components/api-content/test-api/test-api.component';

// zql test api param components
import { TestApiParamComponent } from './components/api-content/test-api/test-api-param/test-api-param.component';
import { TestApiParamTableTextComponent } from './components/api-content/test-api/test-api-param/test-api-param-table-text/test-api-param-table-text.component';
import { TestApiParamColumnTextComponent } from './components/api-content/test-api/test-api-param/test-api-param-column-text/test-api-param-column-text.component';
import { TestApiParamColumnsTextArrComponent } from './components/api-content/test-api/test-api-param/test-api-param-columns-text-arr/test-api-param-columns-text-arr.component';
import { TestApiParamTextComponent } from './components/api-content/test-api/test-api-param/test-api-param-text/test-api-param-text.component';
import { TestApiParamTextArrComponent } from './components/api-content/test-api/test-api-param/test-api-param-text-arr/test-api-param-text-arr.component';
import { TestApiParamTextArrUniqueComponent } from './components/api-content/test-api/test-api-param/test-api-param-text-arr-unique/test-api-param-text-arr-unique.component';
import { TestApiParamColumnsTextArrArrComponent } from './components/api-content/test-api/test-api-param/test-api-param-columns-text-arr-arr/test-api-param-columns-text-arr-arr.component';

// zql services
import { ApiService } from './pages/api/api.service';
import { JsonResultsComponent } from './components/api-content/json-results/json-results.component';
import { JsonResultsVizComponent } from './pages/api/json-results-viz/json-results-viz.component';
import { TestApiParamColumnTextNullComponent } from './components/api-content/test-api/test-api-param/test-api-param-column-text-null/test-api-param-column-text-null.component';
import { QqPlotComponent } from './components/api-content/qq-plot/qq-plot.component';

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
    MultiTreatmentMatchitComponent,
    TwoTableMatchitComponent,
    CausalQuestionsComponent,
    NaiveApproachComponent,
    ConfoundingVariablesComponent,
    AdjustingForCovariatesComponent,
    CheckingBalanceComponent,
    CausalAnswersComponent,
    TestApiComponent,
    TestApiParamComponent,
    TestApiParamTableTextComponent,
    TestApiParamColumnTextComponent,
    TestApiParamColumnsTextArrComponent,
    TestApiParamTextComponent,
    TestApiParamTextArrComponent,
    MatchitCemComponent,
    MatchitPsComponent,
    MatchitCemSummaryStatisticsComponent,
    TestApiParamColumnsTextArrArrComponent,
    JsonResultsComponent,
    JsonResultsVizComponent,
    TestApiParamColumnTextNullComponent,
    QqPlotComponent,
    TestApiParamTextArrUniqueComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    HttpClientModule,
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
    MatInputModule,
    MatSelectModule,
    MatChipsModule,
    MatProgressSpinnerModule,
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
    // zql services
    ApiService,
    // material icons
    MatIconRegistry
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
