import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

// angular router
import { AppRoutingModule } from './app-routing/app-routing.module';

// angular material dependencies
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import 'hammerjs';

// angular material components
import {
  MdButtonModule,
  MdCheckboxModule,
  MdToolbarModule,
  MdGridListModule,
  MdTabsModule,
  MdCardModule,
  MdListModule
} from '@angular/material';

import { AppComponent } from './app.component';
import { HomeComponent } from './home/home.component';
import { DemoComponent } from './demo/demo.component';
import { ImplementationComponent } from './implementation/implementation.component';
import { CitationsComponent } from './citations/citations.component';

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    DemoComponent,
    ImplementationComponent,
    CitationsComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    // angular material components
    MdButtonModule,
    MdCheckboxModule,
    MdToolbarModule,
    MdGridListModule,
    MdTabsModule,
    MdCardModule,
    MdListModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
