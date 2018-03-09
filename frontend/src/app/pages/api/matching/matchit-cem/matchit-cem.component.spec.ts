import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MatchitCemComponent } from './matchit-cem.component';

describe('MatchitCemComponent', () => {
  let component: MatchitCemComponent;
  let fixture: ComponentFixture<MatchitCemComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MatchitCemComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MatchitCemComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
