import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CausalQuestionsComponent } from './causal-questions.component';

describe('CausalQuestionsComponent', () => {
  let component: CausalQuestionsComponent;
  let fixture: ComponentFixture<CausalQuestionsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CausalQuestionsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CausalQuestionsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
