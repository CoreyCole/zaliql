import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { NaiveApproachComponent } from './naive-approach.component';

describe('NaiveApproachComponent', () => {
  let component: NaiveApproachComponent;
  let fixture: ComponentFixture<NaiveApproachComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ NaiveApproachComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(NaiveApproachComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
