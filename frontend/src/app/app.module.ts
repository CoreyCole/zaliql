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
  MdCardModule
} from '@angular/material';

import { AppComponent } from './app.component';
import { HomeComponent } from './home/home.component';

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent
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
    MdCardModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
