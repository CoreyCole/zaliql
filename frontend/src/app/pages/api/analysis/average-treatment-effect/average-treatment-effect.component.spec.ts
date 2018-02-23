import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AverageTreatmentEffectComponent } from './average-treatment-effect.component';

describe('AverageTreatmentEffectComponent', () => {
  let component: AverageTreatmentEffectComponent;
  let fixture: ComponentFixture<AverageTreatmentEffectComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AverageTreatmentEffectComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AverageTreatmentEffectComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
