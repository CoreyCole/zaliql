import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { QqPlotComponent } from './qq-plot.component';

describe('QqPlotComponent', () => {
  let component: QqPlotComponent;
  let fixture: ComponentFixture<QqPlotComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ QqPlotComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(QqPlotComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
