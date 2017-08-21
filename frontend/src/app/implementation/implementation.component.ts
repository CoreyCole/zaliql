import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'zql-implementation',
  templateUrl: './implementation.component.html',
  styleUrls: ['./implementation.component.css']
})
export class ImplementationComponent implements OnInit {
  functions = [
    {
      name: 'Matchit',
      link: 'matchit',
      description: `
        The most simple form of matchit supports multiple binary treatments.
        The results are materialized in a view.
      `,
      code: `
        FUNCTION matchit(
          sourceTable TEXT,        -- input table name
          primaryKey TEXT,         -- source table's primary key
          treatmentsArr TEXT[],    -- array of treatment column names
          covariatesArr TEXT[],    -- array of covariate column names
                                   -- (all covariates are applied to all treatments)
          outputTable TEXT         -- output table name
        ) RETURNS TEXT
      `,
    },
    {
      name: 'Multi Level Treatment Matchit',
      link: 'multi_level_treatment_matchit',
      description: `
        This form of matchit supports 1 non-binary treatment.
        The results are materialized in a view.
      `,
      code: `
        FUNCTION multi_level_treatment_matchit(
          sourceTable TEXT,        -- input table name
          primaryKey TEXT,         -- source table's primary key
          treatment TEXT,          -- treatment column names
          treatmentLevels INTEGER, -- possible levels for given treatment
          covariatesArr TEXT[],    -- array of covariate column names for given treatment
          outputTable TEXT         -- output table name
        ) RETURNS TEXT
      `
    },
    {
      name: 'Multi Treatment Matchit',
      link: 'multi_treatment_matchit',
      description: `
        This form of matchit supports multiple binary treatments each with separate sets of covariates.
        This takes advantage of optimizations made possible by multiple subsequent matchit calls.
        The results are materialized in a view.
      `,
      code: `
        FUNCTION multi_treatment_matchit(
          sourceTable TEXT,             -- input table name
          primaryKey TEXT,              -- source table's primary key
          treatmentsArr TEXT[],         -- array of treatment column names
          covariatesArraysArr TEXT[][], -- array of arrays of covariates, each treatment has its own set of covariates
          outputTableBasename TEXT      -- name used in all output tables, treatment appended
        ) RETURNS TEXT
      `
    },
  ];

  constructor() { }

  ngOnInit() {
  }

}
