SELECT * FROM demo_data_1000 LIMIT 10;

DROP TABLE demo_data_1000_logregr;
DROP TABLE demo_data_1000_logregr_summary;

SELECT madlib.logregr_train(
    'demo_data_1000',                                 -- source table
    'demo_data_1000_logregr',                         -- output table
    'depdel15',                            -- labels
    'ARRAY[1, fog, hail, thunder, lowvisibility, highwindspeed]',       -- features
    NULL,                                       -- grouping columns
    20,                                         -- max number of iteration
    'irls'                                      -- optimizer
    );

SELECT * FROM demo_data_1000_logregr;

SELECT unnest(array['intercept', 'fog', 'hail', 'thunder', 'lowvisibility', 'highwindspeed']) as attribute,
       unnest(coef) as coefficient,
       unnest(std_err) as standard_error,
       unnest(z_stats) as z_stat,
       unnest(p_values) as pvalue,
       unnest(odds_ratios) as odds_ratio
FROM demo_data_1000_logregr;

/**
Add column AS propensityscore
"estimate_propensity_score()"

Greedy algorithm for selecting K nearest neighbor matches given a maximum caliper (without replacement)
Loop over all the treated, pick one control that has the closest propensity score (difference has to be less than the given caliper)
*/