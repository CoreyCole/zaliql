import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { JsonResultsComponent } from './json-results.component';

describe('JsonResultsComponent', () => {
  let component: JsonResultsComponent;
  let fixture: ComponentFixture<JsonResultsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ JsonResultsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(JsonResultsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
