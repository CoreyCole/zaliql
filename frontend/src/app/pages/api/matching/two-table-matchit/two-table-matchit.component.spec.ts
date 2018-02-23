import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TwoTableMatchitComponent } from './two-table-matchit.component';

describe('TwoTableMatchitComponent', () => {
  let component: TwoTableMatchitComponent;
  let fixture: ComponentFixture<TwoTableMatchitComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TwoTableMatchitComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TwoTableMatchitComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
