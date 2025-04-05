-- Sanity Checks
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
