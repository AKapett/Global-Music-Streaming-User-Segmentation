-- Create "clean" table
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
WHERE most_played_artist LIKE '%  %' OR most_played_artist LIKE '%
