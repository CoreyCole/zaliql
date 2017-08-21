import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { HomeComponent } from '../home/home.component';
import { DemoComponent } from '../demo/demo.component';
import { ImplementationComponent } from '../implementation/implementation.component';
import { CitationsComponent } from '../citations/citations.component';

const routes: Routes = [
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  { path: 'home', component: HomeComponent },
  { path: 'demo', component: DemoComponent },
  { path: 'implementation', component: ImplementationComponent },
  { path: 'citations', component: CitationsComponent },
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
