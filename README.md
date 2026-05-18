# Ad Campaign Performance & User Funnel Analysis (SQLite)

---

## 📌 Project Overview

This project explores an adtech dataset containing user interactions with ads, campaign metadata, and user demographics. The goal is to analyze funnel performance, campaign efficiency, and user behavior using SQL in SQLite.

The analysis focuses on real-world ad operations (ad ops) use cases such as:

* Funnel conversion analysis
* Campaign performance optimization
* Audience segmentation
* Attribution-style behavior analysis

---

## 📊 Dataset Overview

This is a simulated data set on Kaggle.
https://www.kaggle.com/datasets/alperenmyung/social-media-advertisement-performance

It has the following tables:

### `ad_events`

User-level interaction events with ads.


Key columns:

* user_id
* ad_id
* event_type (Impression, Click, Like, Share, Comment, Purchase)
* timestamp

---

### `ads`

Metadata about each ad.

Key columns:

* ad_id
* ad_platform (Facebook, Instagram)
* ad_type (Stories, Carousel, Images, Videos)
* keyword
* campaign_id

---

### `campaigns`

Campaign-level information.

Key columns:

* campaign_id
* campaign_name
* start_date
* end_date
* budget

---

### `users`

User demographic and interest data.

Key columns:

* user_id
* gender
* age_group
* interests

---


## 🎯 Business Questions Explored

## Core Ad Performance Analysis

### 1. What is the overall conversion funnel?
<img width="559" height="410" alt="Screen Shot 2026-05-17 at 10 58 04 PM" src="https://github.com/user-attachments/assets/fbbe6faa-fc94-450f-b665-4ec9b061b4e2" />


Conversion rate here is defined as Purchases/Clicks. Engagement here includes click, like, comment, share. 

An engagement rate of 17% is considered strong and reflects high ad quality. Both CTR and conversion rate are strong at 11.79% and 5.07%, which means the **ad attracts users and the downstream experience converts them well**.


### 2. Which ad platform has the highest engagement rate?
<img width="565" height="382" alt="Screen Shot 2026-05-17 at 11 04 19 PM" src="https://github.com/user-attachments/assets/d96677d6-a1d5-489c-a834-ca545f6ee588" />


The data only contains two channels, Facebook and Instagram. While both channels' engagement rates are strong, **Instagram** performs slightly better.


### 3. Which ad type generates the most purchases?
<img width="612" height="577" alt="Screen Shot 2026-05-18 at 11 20 59 AM" src="https://github.com/user-attachments/assets/7db9d46a-ea1e-464f-9a1a-a3d24816a4d3" />


Stories generate the most purchases. However, each ad type's contribution to purchases is proportional to its contribution to impressions, which means **purchase is mostly driven by exposure volume**.

### 4. Which keywords drive the most clicks?
<img width="568" height="786" alt="Screen Shot 2026-05-17 at 11 05 10 PM" src="https://github.com/user-attachments/assets/b742d198-e23a-420e-bc20-709f168234b9" />


### 5. Which campaigns have the best CTR?
<img width="538" height="577" alt="Screen Shot 2026-05-18 at 12 04 20 PM" src="https://github.com/user-attachments/assets/e5379fa4-afb7-4817-8786-5a351127801e" />


Whil the top 5 campaigns with the highest CTR all have CTR over 12%, about 1% to almost 2% higher than the baseline 11.07%, campaign 22 stands out for having significantly lower Cost per Mile (1000 Impressions) and lower Cost per Clcik than the other top performing campaigns.

### 6. Which campaigns have lower Cost Per Acquisition?
<img width="490" height="761" alt="Screen Shot 2026-05-18 at 12 55 11 PM" src="https://github.com/user-attachments/assets/a5ba6310-31b7-4cee-b0c0-0d5f5fe9fe44" />

This is the top 10 campaigns with the lowest Cost per Acquisition, alongside with their Cost per Click. We can easily compare their CPAs and CPCs with average CPA and CPC of all the campaigns and see that they perform significantly better than baseline performance.


## Audience & Segmentation Analysis

### 7. Which age groups convert best?
<img width="481" height="397" alt="Screen Shot 2026-05-17 at 11 10 23 PM" src="https://github.com/user-attachments/assets/85be6c3c-8930-4656-b0ef-7b065c7ea20c" />

### 8. Which interests correlate with higher engagement?
<img width="509" height="437" alt="Screen Shot 2026-05-17 at 11 15 47 PM" src="https://github.com/user-attachments/assets/2db61c78-3112-4e71-9294-cacb3980651d" />

The approach to this question is, first create a long list of interests from the all the user using resursive cte to strip each interest from the string, then aggregate clicks by interest.

### 9. Are some ad platforms more effective for specific demographics?

<img width="505" height="775" alt="Screen Shot 2026-05-17 at 11 12 54 PM" src="https://github.com/user-attachments/assets/3a3898e1-2970-4ca4-b525-af4502a89bea" />



### 10. Which campaign performs best within each demographic segment?

<img width="506" height="580" alt="Screen Shot 2026-05-17 at 11 14 34 PM" src="https://github.com/user-attachments/assets/9f2b8127-ddee-4f7d-a70e-17e7a3ed3879" />
<img width="498" height="574" alt="Screen Shot 2026-05-17 at 11 20 20 PM" src="https://github.com/user-attachments/assets/08e28081-f2ae-4af4-9b8d-f14f1b2af93d" />



## User Journey and Conversion Time Analysis

### 11. What is the typical user journey before purchase?
<img width="503" height="368" alt="Screen Shot 2026-05-17 at 11 21 18 PM" src="https://github.com/user-attachments/assets/095d7f2a-3929-4cb0-ac94-4f7095886e42" />

### 12. How long does it take users to convert?
<img width="504" height="814" alt="Screen Shot 2026-05-17 at 11 22 14 PM" src="https://github.com/user-attachments/assets/4284b7ef-c3ae-4426-9401-6e7d003b4a48" />


---

## 🧪 SQL Concepts Used

This project practices real-world SQL techniques used in analytics and ad ops:

### Core SQL

* SELECT, WHERE, GROUP BY
* Aggregations (COUNT, SUM, AVG)
* CASE WHEN logic


### Advanced SQL

* Window function

* Common Table Expressions (CTEs)

* Subqueries

---

