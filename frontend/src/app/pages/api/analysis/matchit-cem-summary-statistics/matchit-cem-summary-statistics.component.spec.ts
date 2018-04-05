import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MatchitCemSummaryStatisticsComponent } from './matchit-cem-summary-statistics.component';

describe('MatchitCemSummaryStatisticsComponent', () => {
  let component: MatchitCemSummaryStatisticsComponent;
  let fixture: ComponentFixture<MatchitCemSummaryStatisticsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MatchitCemSummaryStatisticsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MatchitCemSummaryStatisticsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
