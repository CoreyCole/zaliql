import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestApiParamTableTextComponent } from './test-api-param-table-text.component';

describe('TestApiParamTableTextComponent', () => {
  let component: TestApiParamTableTextComponent;
  let fixture: ComponentFixture<TestApiParamTableTextComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TestApiParamTableTextComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TestApiParamTableTextComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
