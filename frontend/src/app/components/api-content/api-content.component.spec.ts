import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ApiContentComponent } from './api-content.component';

describe('ApiContentComponent', () => {
  let component: ApiContentComponent;
  let fixture: ComponentFixture<ApiContentComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ApiContentComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ApiContentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
