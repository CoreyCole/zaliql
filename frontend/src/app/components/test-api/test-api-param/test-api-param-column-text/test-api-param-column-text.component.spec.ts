import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestApiParamColumnTextComponent } from './test-api-param-column-text.component';

describe('TestApiParamColumnTextComponent', () => {
  let component: TestApiParamColumnTextComponent;
  let fixture: ComponentFixture<TestApiParamColumnTextComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TestApiParamColumnTextComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TestApiParamColumnTextComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
