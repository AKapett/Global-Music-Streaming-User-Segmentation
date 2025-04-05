**Age Bins =**

IF [Age] >= 13 AND [Age] <= 17 THEN "13–17"
ELSEIF [Age] >= 18 AND [Age] <= 24 THEN "18–24"
ELSEIF [Age] >= 25 AND [Age] <= 34 THEN "25–34"
ELSEIF [Age] >= 35 AND [Age] <= 44 THEN "35–44"
ELSEIF [Age] >= 45 AND [Age] <= 60 THEN "45–60"
ELSE "60+"
END

---

**% Premium at High Churn Risk =**

COUNT(
  IF [Subscription Type] = "Premium" AND [Churn Risk Flag] = "High"
  THEN [User ID]
  END
)
/
COUNT(
  IF [Subscription Type] = "Premium"
  THEN [User ID]
  END
)

---
 
**% Free Users with High Engagement =**

COUNT(
  IF [Subscription Type] = "Free" AND [Engagement Level] = "High"
  THEN [User ID]
  END
)
/
COUNT(
  IF [Subscription Type] = "Free"
  THEN [User ID]
  END
)


