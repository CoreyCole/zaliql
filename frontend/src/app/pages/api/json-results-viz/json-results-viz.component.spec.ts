import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { JsonResultsVizComponent } from './json-results-viz.component';

describe('JsonResultsVizComponent', () => {
  let component: JsonResultsVizComponent;
  let fixture: ComponentFixture<JsonResultsVizComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ JsonResultsVizComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(JsonResultsVizComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
