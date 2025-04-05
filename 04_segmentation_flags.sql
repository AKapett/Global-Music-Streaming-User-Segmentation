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
