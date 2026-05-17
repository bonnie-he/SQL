# AdTech SQL Analytics Project

## Campaign Performance & User Funnel Analysis (SQLite)

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

This is a simulated data set. Link to source: https://www.kaggle.com/datasets/alperenmyung/social-media-advertisement-performance

This project uses a SQLite database with the following tables:

### `ad_events`

User-level interaction events with ads.

Event types include:

* impression
* click
* like
* share
* purchase (conversion proxy)

Key columns:

* user_id
* ad_id
* event_type
* timestamp

---

### `ads`

Metadata about each ad.

Key columns:

* ad_id
* ad_platform
* ad_type
* keyword

---

### `campaigns`

Campaign-level information.

Key columns:

* campaign_id
* campaign_name
* start_date
* end_date

---

### `users`

User demographic and interest data.

Key columns:

* user_id
* gender
* age
* interests

---


## 🎯 Business Questions Explored

## Core Ad Performance Analysis

### 1. What is the overall conversion funnel?


### 2. Which ad platform has the highest engagement rate?


### 3. Which ad type generates the most purchases?


### 4. Which keywords drive the most clicks?


### 5. Which campaigns have the best CTR?


### 6. Which campaigns have high impressions but zero purchases?


## Audience & Segmentation Analysis

### 7. Which age groups convert best?


### 8. Which interests correlate with higher engagement?


### 9. Are some ad platforms more effective for specific demographics?


### 10. Which campaign performs best within each demographic segment?

## User Journey and Conversion Time Analysis

### 11. What is the typical user journey before purchase?


### 12. How long does it take users to convert?

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

