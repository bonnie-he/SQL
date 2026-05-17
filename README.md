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

### Funnel Analysis

* What is the impression → click → purchase conversion rate?
* Where do users drop off in the funnel?

### Campaign Performance

* Which campaigns have the highest CTR?
* Which campaigns have high spend but low conversions?

### Ad & Platform Performance

* Which ad platforms generate the highest engagement?
* Which ad types perform best for conversions?

### Audience Segmentation

* Which age groups convert best?
* Do certain interests correlate with higher engagement?
* How does gender affect ad performance across ad types?

### Keyword Effectiveness

* Which keywords drive the most clicks?
* Which keywords generate clicks but fail to convert?

### Advanced Behavioral Analysis

* What is the last-touch interaction before purchase?
* How do user behaviors change across repeated exposures?
* How long does it take users to convert?

---

## 🧪 SQL Concepts Used

This project practices real-world SQL techniques used in analytics and ad ops:

### Core SQL

* SELECT, WHERE, GROUP BY
* Aggregations (COUNT, SUM, AVG)
* CASE WHEN logic

### Joins

* INNER JOIN
* LEFT JOIN

### Advanced SQL

* Window functions:

  * ROW_NUMBER()
  * RANK()
  * LAG()
  * LEAD()

* Common Table Expressions (CTEs)

* Subqueries

---

## 📈 Key Insights (Expected)

From analysis, typical insights may include:

* Certain ad platforms have high CTR but low conversion efficiency
* Younger users may engage more but convert less
* Some keywords drive high clicks but poor downstream performance
* Campaign performance varies significantly by ad type
* Repeated exposure can reduce time-to-conversion (behavioral effect)

---


adtech-s
```
