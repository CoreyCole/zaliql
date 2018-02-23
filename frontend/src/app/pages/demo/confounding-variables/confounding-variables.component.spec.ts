import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ConfoundingVariablesComponent } from './confounding-variables.component';

describe('ConfoundingVariablesComponent', () => {
  let component: ConfoundingVariablesComponent;
  let fixture: ComponentFixture<ConfoundingVariablesComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ConfoundingVariablesComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ConfoundingVariablesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
