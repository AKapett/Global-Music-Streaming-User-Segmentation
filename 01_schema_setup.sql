-- Create schema
CREATE SCHEMA music_analysis;
USE music_analysis;

-- Check column structure and data types
DESCRIBE users_raw;

-- Preview rows
SELECT * FROM users_raw; 

-- Confirm row count
SELECT COUNT(*) FROM users_raw;
