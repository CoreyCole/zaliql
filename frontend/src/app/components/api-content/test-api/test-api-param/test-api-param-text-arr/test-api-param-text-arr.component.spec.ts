import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestApiParamTextArrComponent } from './test-api-param-text-arr.component';

describe('TestApiParamTextArrComponent', () => {
  let component: TestApiParamTextArrComponent;
  let fixture: ComponentFixture<TestApiParamTextArrComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TestApiParamTextArrComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TestApiParamTextArrComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
