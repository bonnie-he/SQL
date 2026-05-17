# 1. What is the overall conversion funnel?
SELECT
    ROUND(SUM(engagement) * 100.0 / SUM(impressions), 2) as engagement_rate,
    ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) as ctr,
    ROUND(SUM(purchase) * 100.0 / SUM(clicks), 2) as conversion
FROM (
SELECT 
    SUM(CASE WHEN e.event_type = 'Impression' THEN 1 ELSE 0 END) as impressions,
    SUM(CASE WHEN e.event_type = 'Click' THEN 1 ELSE 0 END) as clicks,
    SUM(CASE WHEN e.event_type = 'Purchase' THEN 1 ELSE 0 END) as purchase,
    SUM(CASE WHEN e.event_type in ('Click','Like','Share', 'Comment') THEN 1 ELSE 0 END) as engagement
FROM ad_events e
LEFT JOIN ads a on e.ad_id = a.ad_id
GROUP BY a.ad_platform
) t;

# 2. Which ad platform has the highest engagement rate?
WITH cte AS (
SELECT 
    a.ad_platform,
    SUM(CASE WHEN e.event_type = 'Impression' THEN 1 ELSE 0 END) as impressions,
    SUM(CASE WHEN e.event_type = 'Click' THEN 1 ELSE 0 END) as clicks,
    SUM(CASE WHEN e.event_type = 'Purchase' THEN 1 ELSE 0 END) as purchase,
    SUM(CASE WHEN e.event_type in ('Click','Like','Share', 'Comment') THEN 1 ELSE 0 END) as engagement
FROM ad_events e
LEFT JOIN ads a on e.ad_id = a.ad_id
GROUP BY a.ad_platform
)
SELECT
    ad_platform,
    ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) as ctr,
    ROUND(SUM(engagement) * 100.0 / SUM(impressions), 2) as engagement_rate
FROM cte
GROUP BY ad_platform
ORDER BY engagement_rate desc;

# 3. Which ad type generates the most purchases?
SELECT 
    a.ad_type,
    SUM(CASE WHEN e.event_type = 'Purchase' THEN 1 ELSE 0 END) as purchases
FROM ad_events e
LEFT JOIN ads a on e.ad_id = a.ad_id
GROUP BY a.ad_type
ORDER BY purchases desc;

# 4. Which keywords drive the most clicks?

# see ads and their keywords
SELECT ad_id, target_interests
FROM ads;

# seperate the keywords
SELECT
    ad_id,
    TRIM(SUBSTR(target_interests, 1, INSTR(target_interests || ',', ',') - 1)) AS keyword_1,
    TRIM(SUBSTR(target_interests, INSTR(target_interests, ',') + 1)) AS keyword_2
FROM ads;

# aggregate by keywords and clicks
WITH interests AS (
SELECT
    ad_id,
    keyword_1 AS keyword
FROM (
    SELECT
        ad_id,
        TRIM(SUBSTR(target_interests, 1, INSTR(target_interests || ',', ',') - 1)) AS keyword_1,
        TRIM(SUBSTR(target_interests, INSTR(target_interests, ',') + 1)) AS keyword_2
    FROM ads
)

UNION

SELECT
    ad_id,
    keyword_2 AS keyword
FROM (
    SELECT
        ad_id,
        TRIM(SUBSTR(target_interests, 1, INSTR(target_interests || ',', ',') - 1)) AS keyword_1,
        TRIM(SUBSTR(target_interests, INSTR(target_interests, ',') + 1)) AS keyword_2
    FROM ads
))
SELECT 
    i.keyword,
    SUM(CASE WHEN e.event_type = 'Click' THEN 1 ELSE 0 END) as clicks
FROM interests i
LEFT JOIN ad_events e on e.ad_id = i.ad_id
GROUP BY i.keyword
ORDER BY clicks desc;

# sanity check
SELECT 
    SUM(CASE WHEN e.event_type = 'Click' THEN 1 ELSE 0 END) as clicks
FROM ad_events e
LEFT JOIN ads a on e.ad_id = a.ad_id
WHERE a.target_interests like '%health%';
    
# 5. Which campaigns have the best CTR?
SELECT
    a.campaign_id,
    ROUND(SUM(CASE WHEN e.event_type = 'Click' THEN 1 ELSE 0 END) * 100.0 / SUM(CASE WHEN e.event_type = 'Impression' THEN 1 ELSE 0 END), 2) as ctr
FROM ad_events e
LEFT JOIN ads a on a.ad_id = e.ad_id
GROUP BY a.campaign_id
ORDER BY ctr desc
LIMIT 10;

# 6. Which campaigns have lower Cost Per Acquisition?
WITH ad_purchase AS (
SELECT 
    e.ad_id,
    a.campaign_id,
    SUM(CASE WHEN e.event_type = 'Purchase' THEN 1 ELSE 0 END) as purchase
FROM ad_events e
LEFT JOIN ads a ON e.ad_id = a.ad_id
GROUP BY e.ad_id, a.campaign_id
)
SELECT 
    c.campaign_id,
    SUM(purchase) as purchase,
    c.total_budget,
    ROUND(c.total_budget/SUM(purchase),2) as cpa
FROM ad_purchase a
LEFT JOIN campaigns c ON a.campaign_id = c.campaign_id
GROUP BY c.campaign_id
ORDER BY cpa asc
LIMIT 5;

# 7. Which age groups convert best?
SELECT
    u.age_group,
    ROUND(SUM(CASE WHEN e.event_type = 'Purchase' THEN 1 ELSE 0 END) * 100.0 / SUM(CASE WHEN e.event_type = 'Click' THEN 1 ELSE 0 END), 3) as conversion
FROM ad_events e
LEFT JOIN users u on e.user_id = u.user_id
GROUP BY u.age_group
ORDER BY conversion desc;

# 8. Which interests correlate with higher engagement?

# a loop to separate the words in interest

WITH RECURSIVE split(user_id, interest, rest) AS (
    SELECT
        user_id,
        '',
        interests || ','
    FROM users

    UNION ALL

    SELECT
        user_id,
        TRIM(SUBSTR(rest, 1, INSTR(rest, ',') - 1)) AS interest,
        SUBSTR(rest, INSTR(rest, ',') + 1) AS rest
    FROM split
    WHERE rest != ''
),
interests AS (
    SELECT user_id, interest
    FROM split
    WHERE interest != ''
)
SELECT 
    i.interest,
    SUM(CASE WHEN e.event_type in ('Click','Like','Share', 'Comment')THEN 1 ELSE 0 END) as engagement
FROM interests i
LEFT JOIN ad_events e on e.user_id = i.user_id
GROUP BY i.interest
ORDER BY engagement desc;

# 9. Are some ad platforms more effective for specific demographics?
WITH cte as (
SELECT
    e.user_id,
    a.ad_platform,
    SUM(CASE WHEN e.event_type = 'Impression' THEN 1 ELSE 0 END) as impressions,
    SUM(CASE WHEN e.event_type = 'Click' THEN 1 ELSE 0 END) as clicks,
    SUM(CASE WHEN e.event_type = 'Purchase' THEN 1 ELSE 0 END) as purchases
FROM ad_events e 
LEFT JOIN ads a on e.ad_id = a.ad_id
GROUP BY e.user_id, a.ad_platform
)
SELECT
    u.age_group,
    c.ad_platform,
    ROUND(SUM(c.clicks) * 100.0 / SUM(c.impressions), 2) as ctr,
    ROUND(SUM(c.purchases) * 100.0 / SUM(c.clicks), 2) as conversion
FROM cte c
LEFT JOIN users u on c.user_id = u.user_id
GROUP BY u.age_group, c.ad_platform
ORDER BY conversion desc;

# 10. Which campaign performs best within each demographic segment?
WITH user_segments AS (
    SELECT
        user_id,
        CONCAT(user_gender, ' ',  age_group) as segment
    FROM users
),

campaign_performance AS (
SELECT
    e.user_id,
    a.campaign_id,
    SUM(CASE WHEN e.event_type = 'Impression' THEN 1 ELSE 0 END) as impressions,
    SUM(CASE WHEN e.event_type = 'Click' THEN 1 ELSE 0 END) as clicks,
    SUM(CASE WHEN e.event_type = 'Purchase' THEN 1 ELSE 0 END) as purchases
FROM ad_events e
LEFT JOIN ads a on e.ad_id = a.ad_id
GROUP BY e.user_id, a.campaign_id
),

segment_campaign_performance as (
SELECT 
    u.segment,
    c.campaign_id,
    ROUND(SUM(clicks) * 100.0 / SUM(impressions),2) as ctr,
    ROUND(SUM(purchases) * 100.0 / SUM(clicks),2) as conversion
FROM campaign_performance c
LEFT JOIN user_segments u ON u.user_id = c.user_id
GROUP BY u.segment, c.campaign_id
),

ranking as (
SELECT 
    *,
    ROW_NUMBER() OVER (
            PARTITION BY segment
            ORDER BY ctr DESC
        ) AS rn
FROM segment_campaign_performance
)

SELECT
    segment,
    campaign_id,
    ctr,
    conversion
FROM ranking
WHERE rn = 1
ORDER by segment, rn asc;

# 11. What is the typical user journey before purchase?
WITH cte as (
SELECT
    user_id,
    MIN(timestamp) as first_contact,
    event_type,
    ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY MIN(timestamp) ASC    
            ) as step_number            
FROM ad_events
GROUP BY user_id, event_type
),

user_steps as (
SELECT
    user_id,
    event_type,
    step_number
FROM cte
ORDER BY user_id, step_number asc
),

user_paths as (
SELECT
    user_id,
    GROUP_CONCAT(event_type, '-') as journey
FROM user_steps
GROUP BY user_id
)

SELECT
    journey,
    COUNT(user_id) as total_users
FROM user_paths
WHERE journey like '%Purchase'
GROUP BY journey
ORDER BY total_users desc
LIMIT 10;

# 12. How long does it take users to convert?

WITH first_purchase as (
SELECT
    user_id,
    MIN(timestamp) as first_purchase
FROM ad_events
WHERE event_type = 'Purchase'
GROUP BY user_id
),

first_contact as (
SELECT
    user_id,
    MIN(timestamp) as first_step
FROM ad_events
GROUP BY user_id
),

conversion_time as (
SELECT
    p.user_id,
    c.first_step,
    p.first_purchase,
    ROUND(julianday(p.first_purchase) - julianday(c.first_step),2) as duration
FROM first_purchase p
LEFT JOIN first_contact c
ON p.user_id = c.user_id
),

ranked as (
SELECT
    user_id,
    duration,
    ROW_NUMBER() OVER(ORDER BY duration ASC) AS rn,
    COUNT(*) OVER () AS total
FROM conversion_time
)
SELECT
    MAX(CASE WHEN rn = CAST(total * 0.25 AS INT) THEN duration END) AS p25,
    MAX(CASE WHEN rn = CAST(total * 0.5 AS INT) THEN duration END) AS p50,
    MAX(CASE WHEN rn = CAST(total * 0.75 AS INT) THEN duration END) AS p75
FROM ranked;
