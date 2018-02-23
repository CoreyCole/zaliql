import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MatchitSummaryStatisticsComponent } from './matchit-summary-statistics.component';

describe('MatchitSummaryStatisticsComponent', () => {
  let component: MatchitSummaryStatisticsComponent;
  let fixture: ComponentFixture<MatchitSummaryStatisticsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MatchitSummaryStatisticsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MatchitSummaryStatisticsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
