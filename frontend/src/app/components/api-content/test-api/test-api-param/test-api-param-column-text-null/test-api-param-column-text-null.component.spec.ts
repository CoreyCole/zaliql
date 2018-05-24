import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestApiParamColumnTextNullComponent } from './test-api-param-column-text-null.component';

describe('TestApiParamColumnTextNullComponent', () => {
  let component: TestApiParamColumnTextNullComponent;
  let fixture: ComponentFixture<TestApiParamColumnTextNullComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TestApiParamColumnTextNullComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TestApiParamColumnTextNullComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
