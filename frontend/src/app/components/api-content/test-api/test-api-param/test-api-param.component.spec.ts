import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestApiParamComponent } from './test-api-param.component';

describe('TestApiParamComponent', () => {
  let component: TestApiParamComponent;
  let fixture: ComponentFixture<TestApiParamComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TestApiParamComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TestApiParamComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
