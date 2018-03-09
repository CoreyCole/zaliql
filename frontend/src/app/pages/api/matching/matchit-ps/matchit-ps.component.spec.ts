import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MatchitPsComponent } from './matchit-ps.component';

describe('MatchitPsComponent', () => {
  let component: MatchitPsComponent;
  let fixture: ComponentFixture<MatchitPsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MatchitPsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MatchitPsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
