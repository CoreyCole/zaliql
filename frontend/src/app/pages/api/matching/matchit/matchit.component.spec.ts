import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MatchitComponent } from './matchit.component';

describe('MatchitComponent', () => {
  let component: MatchitComponent;
  let fixture: ComponentFixture<MatchitComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MatchitComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MatchitComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
