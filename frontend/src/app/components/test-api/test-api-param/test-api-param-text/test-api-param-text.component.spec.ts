import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestApiParamTextComponent } from './test-api-param-text.component';

describe('TestApiParamTextComponent', () => {
  let component: TestApiParamTextComponent;
  let fixture: ComponentFixture<TestApiParamTextComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TestApiParamTextComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TestApiParamTextComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
