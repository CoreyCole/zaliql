import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestApiParamColumnsTextArrComponent } from './test-api-param-columns-text-arr.component';

describe('TestApiParamColumnsTextArrComponent', () => {
  let component: TestApiParamColumnsTextArrComponent;
  let fixture: ComponentFixture<TestApiParamColumnsTextArrComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TestApiParamColumnsTextArrComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TestApiParamColumnsTextArrComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
