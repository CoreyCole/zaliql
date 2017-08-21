import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ImplementationComponent } from './implementation.component';

describe('ImplementationComponent', () => {
  let component: ImplementationComponent;
  let fixture: ComponentFixture<ImplementationComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ImplementationComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ImplementationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });
});
