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
        CREATE FUNCTION matchit(
          sourceTable TEXT,     -- input table name
          primaryKey TEXT,      -- source table's primary key
          treatmentsArr TEXT[], -- array of treatment column names
          covariatesArr TEXT[], -- array of covariate column names
                                -- (all covariates are applied to all treatments)
          outputTable TEXT      -- output table name
        ) RETURNS TEXT          -- RETURNS function call status TEXT
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
        CREATE FUNCTION multi_level_treatment_matchit(
          sourceTable TEXT,        -- input table name
          primaryKey TEXT,         -- source table's primary key
          treatment TEXT,          -- treatment column names
          treatmentLevels INTEGER, -- possible levels for given treatment
          covariatesArr TEXT[],    -- array of covariate column names for given treatment
          outputTable TEXT         -- output table name
        ) RETURNS TEXT             -- RETURNS function call status TEXT
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
        CREATE FUNCTION multi_treatment_matchit(
          sourceTable TEXT,             -- input table name
          primaryKey TEXT,              -- source table's primary key
          treatmentsArr TEXT[],         -- array of treatment column names
          covariatesArraysArr TEXT[][], -- array of arrays of covariates, each treatment has its own set of covariates
          outputTableBasename TEXT      -- name used in all output tables, treatment appended
        ) RETURNS TEXT                  -- RETURNS function call status TEXT
      `
    },
    {
      name: 'Two Table Matchit',
      link: 'two_table_matchit',
      description: `
        This form of matchit supports joining data from two tables and matching on 1 binary treatment.
        Prunes rows from input table A first to optimize join.
        The results are materialized in a view.
      `,
      code: `
        CREATE FUNCTION two_table_matchit(
          sourceTableA TEXT,           -- input table A name
          sourceTableAPrimaryKey TEXT, -- input table A primary key
          sourceTableAForeignKey TEXT, -- foreign key linking to input table B
          covariatesArrA TEXT[],       -- covariates included in input table A
          sourceTableB TEXT,           -- input table B name
          sourceTableBPrimaryKey TEXT, -- input table B primary key
          covariatesArrB TEXT[],       -- covariates included in input table B
          treatment TEXT,              -- treatment column must be in sourceTableA
          treatmentLevels INTEGER,     -- possible levels for given treatment
          outputTable TEXT             -- output table name
        ) RETURNS TEXT                 -- RETURNS function call status TEXT
      `
    },
    {
      name: 'Average Treatment Effect (ATE)',
      link: 'ate',
      description: `
        This computes the average treatment effect that the given treatment has on the given outcome
        weighted on the size of the groups made by the exact match of covariates.
      `,
      code: `
        CREATE FUNCTION ate(
          sourceTable TEXT,         -- input table name that was output by matchit
          outcome TEXT,             -- column name of the outcome of interest
          treatment TEXT,           -- column name of the treatment of interest
          covariatesArr TEXT[]      -- array of covariate column names
        ) RETURNS NUMERIC           -- RETURNS ate NUMERIC
      `
    },
    {
      name: 'Matching Summary',
      link: 'matchit_summary',
      description: `
        Computes summary statistics of matching operation.
        Returns a JSON object containing summary for original data and data after matching.
      `,
      code: `
        CREATE FUNCTION matchit_summary(
          originalSourceTable TEXT, -- original input table name
          matchedSourceTable TEXT,  -- table name that was output by matchit
          treatment TEXT,           -- treatment column name
          covariatesArr TEXT[],     -- array of covariate column names
          outcome TEXT              -- outcome column name
        ) RETURNS JSON              -- RETURNS summary object JSON
      `
    },
  ];

  constructor() { }

  ngOnInit() {
  }

}
