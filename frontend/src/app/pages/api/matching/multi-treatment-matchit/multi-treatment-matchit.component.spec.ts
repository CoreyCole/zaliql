import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MultiTreatmentMatchitComponent } from './multi-treatment-matchit.component';

describe('MultiTreatmentMatchitComponent', () => {
  let component: MultiTreatmentMatchitComponent;
  let fixture: ComponentFixture<MultiTreatmentMatchitComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MultiTreatmentMatchitComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MultiTreatmentMatchitComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
