# Global Music Streaming: Risk and Opportunity  
*Behavioral segmentation of 5,000 music streaming users to identify retention risks, upsell-ready segments, and engagement opportunities across Spotify, Apple Music, YouTube, and more.*



## Overview
This project explores user behavior across major music platforms to uncover insights related to engagement trends, revenue potential, and early indicators of user attrition. By segmenting listeners based on streaming intensity, subscription type, genre preferences, and age group, I designed an interactive dashboard to support targeted strategy development and monetization initiatives.



## Tableau Dashboard

[View the Dashboard on Tableau Public](https://public.tableau.com/views/GlobalMusicStreamingRiskandOpportunity/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)



## Project Files

- `music.analysis.user_cleaned` – Final cleaned dataset  
- `music.analysis.sql_queries` – Full SQL scripts from import to export  
- `Action Log - Global Music Streaming Analysis` – Detailed action log with all transformations and decisions
- [Kaggle Dataset](https://www.kaggle.com/datasets/atharvasoundankar/global-music-streaming-trends-and-listener-insights)


## Key Insights

- **Premium Risk Indicators**: *Isolated Premium users with low engagement and weak loyalty signals, flagging potential drop-off risk.*

- **Upsell-Ready Free Users**: *Identified high-activity Free users who exhibit strong conversion potential.*

- **Behavioral Trends**: *Mapped engagement patterns by age, genre, and listening time to inform targeting strategies.*

- **Regional Patterns**: *Visualized user activity and loyalty signals across countries to support localized planning.*

- **Platform-Level Filtering**: *Enabled dynamic platform-specific analysis to tailor content and retention efforts.*



## Tech Stack
- **SQL (MySQL)**
- **Tableau**
- **Dataset**



## Methodology
**1. Data Cleaning & Validation**
- Renamed and standardized all fields
- Conducted null checks, distribution scans, and logic validation


**2. Feature Engineering**

Created behavioral segments:
  - Engagement Level: Based on daily streaming volume
  - Repeat Listener Flag: Based on song repeat rate
  - Upgrade Potential: For Free users with high activity
  - Churn Risk Flag: Custom logic combining low engagement and low affinity behaviors


**3. Visualization Development**

Designed multi-panel dashboard with:

- KPI cards for churn and upgrade percentages
- Age & genre-based bar charts for user patterns
- Listening time analysis by age group and subscription type
- Country-level segmentation
- Cross-platform filtering



## Limitations & Future Opportunities

While the segmentation provides actionable insights, the dataset’s limitations prevent full churn modeling:

- **Lack of session timestamps** – prevents true cohort or retention curve analysis

- **No subscription timeline data** – limits confirmation of actual churn events

- **Future Direction:** With longitudinal user data, I could implement churn prediction models using survival analysis or logistic regression to estimate real attrition likelihood.






