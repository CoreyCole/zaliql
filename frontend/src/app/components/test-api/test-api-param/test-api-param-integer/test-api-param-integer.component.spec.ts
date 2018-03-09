import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestApiParamIntegerComponent } from './test-api-param-integer.component';

describe('TestApiParamIntegerComponent', () => {
  let component: TestApiParamIntegerComponent;
  let fixture: ComponentFixture<TestApiParamIntegerComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TestApiParamIntegerComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TestApiParamIntegerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
