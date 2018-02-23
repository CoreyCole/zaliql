import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BinEqualWidthComponent } from './bin-equal-width.component';

describe('BinEqualWidthComponent', () => {
  let component: BinEqualWidthComponent;
  let fixture: ComponentFixture<BinEqualWidthComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BinEqualWidthComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BinEqualWidthComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
