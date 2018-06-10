import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestApiParamTextArrUniqueComponent } from './test-api-param-text-arr-unique.component';

describe('TestApiParamTextArrUniqueComponent', () => {
  let component: TestApiParamTextArrUniqueComponent;
  let fixture: ComponentFixture<TestApiParamTextArrUniqueComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TestApiParamTextArrUniqueComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TestApiParamTextArrUniqueComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
