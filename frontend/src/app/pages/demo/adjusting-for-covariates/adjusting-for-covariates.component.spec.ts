import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AdjustingForCovariatesComponent } from './adjusting-for-covariates.component';

describe('AdjustingForCovariatesComponent', () => {
  let component: AdjustingForCovariatesComponent;
  let fixture: ComponentFixture<AdjustingForCovariatesComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AdjustingForCovariatesComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AdjustingForCovariatesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
