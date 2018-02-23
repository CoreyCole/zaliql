import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CausalAnswersComponent } from './causal-answers.component';

describe('CausalAnswersComponent', () => {
  let component: CausalAnswersComponent;
  let fixture: ComponentFixture<CausalAnswersComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CausalAnswersComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CausalAnswersComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
