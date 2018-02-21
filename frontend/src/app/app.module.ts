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
  MatSlideToggleModule
} from '@angular/material';

// ngx charts
import {
  BarChartModule
} from '@swimlane/ngx-charts';

// ngx datatable
import { NgxDatatableModule } from '@swimlane/ngx-datatable';

// highlightJS
import { HighlightJsModule, HighlightJsService } from 'angular2-highlight-js';

import { AppComponent } from './app.component';
import { HomeComponent } from './home/home.component';
import { DemoComponent } from './demo/demo.component';
import { ImplementationComponent } from './implementation/implementation.component';
import { CitationsComponent } from './citations/citations.component';
import { GroupedVerticalBarChartComponent } from './demo/grouped-vertical-bar-chart/grouped-vertical-bar-chart.component';

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    DemoComponent,
    ImplementationComponent,
    CitationsComponent,
    GroupedVerticalBarChartComponent
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
    // ngx charts components
    BarChartModule,
    // ngx datatable
    NgxDatatableModule,
    // highlightJS
    HighlightJsModule
  ],
  providers: [
    HighlightJsService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
