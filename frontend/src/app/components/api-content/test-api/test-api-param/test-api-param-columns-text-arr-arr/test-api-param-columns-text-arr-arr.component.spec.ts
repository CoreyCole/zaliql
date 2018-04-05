import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestApiParamColumnsTextArrArrComponent } from './test-api-param-columns-text-arr-arr.component';

describe('TestApiParamColumnsTextArrArrComponent', () => {
  let component: TestApiParamColumnsTextArrArrComponent;
  let fixture: ComponentFixture<TestApiParamColumnsTextArrArrComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TestApiParamColumnsTextArrArrComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TestApiParamColumnsTextArrArrComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
