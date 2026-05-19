# 🛒 E-Commerce Sales Funnel Analysis (BigQuery SQL)

## 📌 Project Overview

This project analyzes user behavior across an e-commerce sales funnel using event-level data in **Google BigQuery**.  
The goal is to understand where users drop off, which traffic sources perform best, how long it takes to convert, and how much revenue the funnel generates.

---

## 🗂️ Dataset

- **Platform:** Google BigQuery
- **Table:** `User_Event`
- **Fields:**

| Column | Description |
|---|---|
| event_id | Unique ID for each event |
| user_id | Unique ID for each user |
| event_type | Type of action (page_view, add_to_cart, etc.) |
| event_date | Timestamp of the event |
| product_id | Product involved in the event |
| amount | Purchase amount (only for purchases) |
| traffic_source | Where the user came from (organic, email, etc.) |

- **Funnel Events Tracked:**  
  `page_view` → `add_to_cart` → `checkout_start` → `payment_info` → `purchase`

---

## 📊 Analyses Performed

### Query 1 — Funnel Stage Counts
> How many unique users reached each stage of the funnel?

| stage_1_views | stage_2_cart | stage_3_checkout | stage_4_payment | stage_5_purchased |
|---|---|---|---|---|
| 5000 | 1553 | 1103 | 899 | 826 |

---

### Query 2 — Conversion Rates Through the Funnel
> What percentage of users moved from one stage to the next?

| stage_1_views | stage_2_cart | view_to_cart_rate | stage_3_checkout | cart_to_checkout_rate | stage_4_payment | checkout_to_payment_rate | stage_5_purchased | payment_to_purchase_rate | overall_conv_rate |
|---|---|---|---|---|---|---|---|---|---|
| 5000 | 1553 | 31% | 1103 | 71% | 899 | 82% | 826 | 92% | 17% |

**💡 Key Insight:** The biggest drop-off is at the very first step — only **31%** of visitors add something to cart. Once users start checkout, they complete it at a high rate (82–92%).

---

### Query 3 — Funnel Performance by Traffic Source
> Which traffic source brings the most valuable users?

| traffic_source | views | carts | purchases | view_to_cart_rate | purchase_conv_rate | cart_to_purchase_rate |
|---|---|---|---|---|---|---|
| organic | 2038 | 669 | 343 | 32.8% | 51.3% | 16.8% |
| paid_ads | 968 | 358 | 204 | 37.0% | 57.0% | 21.1% |
| email | 522 | 326 | 177 | 62.5% | 54.3% | 33.9% |
| social | 1472 | 200 | 102 | 13.6% | 51.0% | 6.9% |

**💡 Key Insight:** **Email** has the highest conversion rate (62.5%) despite the fewest views — email users are highly intent-driven. **Social media** brings good traffic but converts very poorly (6.9%) — needs optimization.

---

### Query 4 — Time to Conversion Analysis
> How long does it take a user to go from viewing to purchasing?

| converted_users | avg_view_to_cart (mins) | avg_cart_to_purchase (mins) | avg_total_journey (mins) |
|---|---|---|---|
| 826 | 11.16 | 13.47 | 24.63 |

**💡 Key Insight:** Users who convert do so in under **25 minutes** on average — this is a fast decision-making funnel, suggesting users come in with buying intent.

---

### Query 5 — Revenue Funnel Analysis
> What is the revenue impact of the funnel?

| Total_Visitors | Total_Purchases | Total_Revenue | Total_Orders | Revenue_Per_Order | Revenue_Per_Visitor | Revenue_Per_Purchase |
|---|---|---|---|---|---|---|
| 5000 | 826 | $87,975.11 | 826 | $106.51 | $17.60 | $106.51 |

**💡 Key Insight:** Every visitor is worth **$17.60** on average to the business. With a 17% overall conversion rate, improving top-of-funnel (view → cart) even slightly would have a big revenue impact.

---

## 🔑 Key Findings Summary

- 📉 **Biggest drop-off** is View → Cart (only 31% convert) — this is the #1 area to improve
- 📧 **Email is the best channel** — highest conversion rate at 62.5%
- 📱 **Social media underperforms** — 1472 views but only 6.9% cart-to-purchase rate
- ⚡ **Fast funnel** — average user converts in just ~25 minutes
- 💰 **$87,975 total revenue** from 5000 visitors at $106.51 per order

---

## 🛠️ Tools Used

- **Google BigQuery** — SQL querying and data analysis
- **SQL Concepts Used:** CTEs (`WITH`), `COUNT DISTINCT`, `CASE WHEN`, `TIMESTAMP_DIFF`, `ROUND`, aggregations, filtering

---

## 📁 Project Structure

```
ecommerce-funnel-analysis/
│
├── README.md
└── queries/
    ├── 01_funnel_stages.sql
    ├── 02_conversion_rates.sql
    ├── 03_funnel_by_source.sql
    ├── 04_time_to_conversion.sql
    └── 05_revenue_analysis.sql
```

---

## 🚀 How to Run

1. Upload the `User_Event` dataset to your BigQuery project
2. Update the table reference in each query: `` `your-project.your_dataset.User_Event` ``
3. Run queries in order from `01` to `05`

---

*Project by Yash | BigQuery SQL Portfolio Project*
