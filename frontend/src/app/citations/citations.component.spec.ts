import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CitationsComponent } from './citations.component';

describe('CitationsComponent', () => {
  let component: CitationsComponent;
  let fixture: ComponentFixture<CitationsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CitationsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CitationsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });
});
