-- CREATED SCHEMA
CREATE SCHEMA music_analysis;
USE music_analysis;


-- QUICK SCHEMA CHECK
-- Check column structure and data types
DESCRIBE users_raw;
-- Preview rows
SELECT * FROM users_raw; 
-- Confirm row count
SELECT COUNT(*) FROM users_raw;


-- CREATE CLEAN TABLE
CREATE TABLE users_cleaned AS
SELECT 
  `User_ID` AS user_id,
  `Age` AS age,
  `Country` AS country,
  `Streaming Platform` AS streaming_platform,
  `Top Genre` AS top_genre,
  `Minutes Streamed Per Day` AS minutes_streamed_per_day,
  `Number of Songs Liked` AS number_of_songs_liked,
  `Most Played Artist` AS most_played_artist,
  `Subscription Type` AS subscription_type,
  `Listening Time (Morning/Afternoon/Night)` AS listening_time,
  `Discover Weekly Engagement (%)` AS discover_weekly_engagement,
  `Repeat Song Rate (%)` AS repeat_song_rate
FROM users_raw;


-- DIAGNOSTICS CHECK
-- Check for NULLs in each column:
SELECT 
  SUM(user_id IS NULL) AS null_user_id,
  SUM(age IS NULL) AS null_age,
  SUM(country IS NULL) AS null_country,
  SUM(streaming_platform IS NULL) AS null_streaming_platform,
  SUM(top_genre IS NULL) AS null_top_genre,
  SUM(minutes_streamed_per_day IS NULL) AS null_minutes_streamed,
  SUM(number_of_songs_liked IS NULL) AS null_liked_songs,
  SUM(most_played_artist IS NULL) AS null_most_played,
  SUM(subscription_type IS NULL) AS null_subscription,
  SUM(listening_time IS NULL) AS null_listening_time,
  SUM(discover_weekly_engagement IS NULL) AS null_dwe,
  SUM(repeat_song_rate IS NULL) AS null_repeat_rate
FROM users_cleaned;

-- Check for duplicate user IDs:
SELECT user_id, COUNT(*) AS dupes
FROM users_cleaned
GROUP BY user_id
HAVING COUNT(*) > 1;

-- Check case-variant duplicates
SELECT LOWER(TRIM(most_played_artist)) AS cleaned_name, COUNT(*) 
FROM users_cleaned
GROUP BY cleaned_name
HAVING COUNT(*) > 1;

-- Check unique values in key categorical columns:
SELECT DISTINCT subscription_type FROM users_cleaned;
SELECT DISTINCT listening_time FROM users_cleaned;
SELECT DISTINCT streaming_platform FROM users_cleaned;
SELECT DISTINCT top_genre FROM users_cleaned ORDER BY top_genre;
SELECT DISTINCT country FROM users_cleaned ORDER BY country;
SELECT DISTINCT subscription_type FROM users_cleaned ORDER BY subscription_type;

-- Spot suspicious spacing
SELECT most_played_artist
FROM users_cleaned
WHERE most_played_artist LIKE '%  %' OR most_played_artist LIKE '% ' OR most_played_artist LIKE ' %';


-- SANITY CHECKS
-- Percentage fields should be between 0 and 100
SELECT * FROM users_cleaned
WHERE repeat_song_rate < 0 OR repeat_song_rate > 100
   OR discover_weekly_engagement < 0 OR discover_weekly_engagement > 100;

-- Count/time fields should be non-negative
SELECT * FROM users_cleaned
WHERE minutes_streamed_per_day < 0 OR number_of_songs_liked < 0;

-- Empty string checks for key categorical fields
SELECT * FROM users_cleaned
WHERE TRIM(country) = '' 
   OR TRIM(streaming_platform) = '' 
   OR TRIM(subscription_type) = '';

-- Check for any unrealistic listening patterns (e.g., > 1000 minutes streamed per day)
SELECT * FROM users_cleaned
WHERE minutes_streamed_per_day > 1000;


-- BEHAVIORAL LOGIC CHECKS
-- Check for users with very low minutes streamed but very high repeat rate (could be dirty logic)
SELECT * FROM users_cleaned
WHERE minutes_streamed_per_day < 30 AND repeat_song_rate >= 80;

-- Check for Free users with unusually high Discover Weekly engagement
SELECT * FROM users_cleaned
WHERE subscription_type = 'Free' AND discover_weekly_engagement >= 80;

-- How many Free users with unusually high Discover Weekly engagement
SELECT Count(*) FROM users_cleaned
WHERE subscription_type = 'Free' AND discover_weekly_engagement >= 80;

-- Check for users with high repeat rate but zero or very low number of liked songs
SELECT * FROM users_cleaned
WHERE repeat_song_rate >= 50 AND number_of_songs_liked < 5;

-- How many users with high repeat rate but zero or very low number of liked songs
SELECT Count(*) FROM users_cleaned
WHERE repeat_song_rate >= 50 AND number_of_songs_liked < 5;


-- VALUE DISTRIBUTION CHECK
-- Minutes streamed per day
SELECT 
  MIN(minutes_streamed_per_day) AS min_streamed,
  MAX(minutes_streamed_per_day) AS max_streamed,
  AVG(minutes_streamed_per_day) AS avg_streamed,
  COUNT(*) AS total_users
FROM users_cleaned;

-- Repeat song rate
SELECT 
  MIN(repeat_song_rate) AS min_repeat,
  MAX(repeat_song_rate) AS max_repeat,
  AVG(repeat_song_rate) AS avg_repeat
FROM users_cleaned;

-- Discover Weekly engagement
SELECT 
  MIN(discover_weekly_engagement) AS min_dwe,
  MAX(discover_weekly_engagement) AS max_dwe,
  AVG(discover_weekly_engagement) AS avg_dwe
FROM users_cleaned;

-- Number of songs liked
SELECT 
  MIN(number_of_songs_liked) AS min_liked,
  MAX(number_of_songs_liked) AS max_liked,
  AVG(number_of_songs_liked) AS avg_liked
FROM users_cleaned;


-- SEGMENTED COLUMNS
-- Add three segmentation columns at the end of the table
ALTER TABLE users_cleaned
  ADD COLUMN engagement_level VARCHAR(10),
  ADD COLUMN repeat_listener_flag VARCHAR(15),
  ADD COLUMN upgrade_potential_flag VARCHAR(5);

-- Set engagement level based on minutes streamed per day
UPDATE users_cleaned
SET engagement_level = CASE
    WHEN minutes_streamed_per_day >= 500 THEN 'High'
    WHEN minutes_streamed_per_day >= 250 AND minutes_streamed_per_day < 500 THEN 'Medium'
    ELSE 'Low'
END;

-- Set repeat listener flag based on repeat song rate
UPDATE users_cleaned
SET repeat_listener_flag = CASE
    WHEN repeat_song_rate >= 50 THEN 'Loyal'
    WHEN repeat_song_rate >= 20 AND repeat_song_rate < 50 THEN 'Casual'
    ELSE 'Low-Repeat'
END;

-- Flag high potential Free users who might upgrade
UPDATE users_cleaned
SET upgrade_potential_flag = CASE
    WHEN subscription_type = 'Free' AND minutes_streamed_per_day >= 500 THEN 'Yes'
    ELSE 'No'
END;


-- CREATED CHURN RISK FLAG
-- Add churn_risk_flag column
ALTER TABLE users_cleaned
ADD COLUMN churn_risk_flag VARCHAR(10);

-- Update churn risk levels based on behavioral logic
UPDATE users_cleaned
SET churn_risk_flag = CASE
    -- High risk: Low engagement + weak supporting signals
    WHEN engagement_level = 'Low' AND (
         repeat_song_rate < 20 OR
         number_of_songs_liked < 5 OR
         discover_weekly_engagement < 20
    ) THEN 'High'

    -- Moderate risk: Low engagement but decent supporting activity
    WHEN engagement_level = 'Low' AND 
         repeat_song_rate >= 20 AND
         number_of_songs_liked >= 5 AND
         discover_weekly_engagement >= 20 THEN 'Moderate'

    -- Low risk: Everyone else (Medium/High engagement or Loyal behavior)
    ELSE 'Low'
END;


-- EXPORTED CLEANED CSV AND IMPORTED TO TABLEAU
