SELECT bin_equal_width('flight', 'distance vism', 'test_flight', '10 9');

-- use this to veriy types, not working with dynamic sql for some reason
SELECT data_type FROM information_schema.columns WHERE table_name = 'flight' AND column_name = 'distance';

DROP FUNCTION bin_equal_width(text,text,text,text);
