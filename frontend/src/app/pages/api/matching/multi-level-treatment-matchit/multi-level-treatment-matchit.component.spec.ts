import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MultiLevelTreatmentMatchitComponent } from './multi-level-treatment-matchit.component';

describe('MultiLevelTreatmentMatchitComponent', () => {
  let component: MultiLevelTreatmentMatchitComponent;
  let fixture: ComponentFixture<MultiLevelTreatmentMatchitComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MultiLevelTreatmentMatchitComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MultiLevelTreatmentMatchitComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
