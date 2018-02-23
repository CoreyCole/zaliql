import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CheckingBalanceComponent } from './checking-balance.component';

describe('CheckingBalanceComponent', () => {
  let component: CheckingBalanceComponent;
  let fixture: ComponentFixture<CheckingBalanceComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CheckingBalanceComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CheckingBalanceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
