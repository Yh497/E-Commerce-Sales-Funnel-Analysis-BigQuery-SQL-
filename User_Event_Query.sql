SELECT *
FROM `project-bc6bbdcb-3ed5-46f0-be4.Yash.User_Event`
LIMIT
  1000
    -- Define the Sales Funnel and The Different Stages
    WITH
      funnel_stage AS (
      SELECT
        COUNT(DISTINCT CASE WHEN event_type = "page_view" THEN user_id END)
          AS stage_1_views,
        COUNT(DISTINCT CASE WHEN event_type = "add_to_cart" THEN user_id END)
          AS stage_2_cart,
        COUNT(DISTINCT CASE WHEN event_type = "checkout_start" THEN user_id END)
          AS stage_3_checkout,
        COUNT(DISTINCT CASE WHEN event_type = "payment_info" THEN user_id END)
          AS stage_4_payment,
        COUNT(DISTINCT CASE WHEN event_type = "purchase" THEN user_id END)
          AS stage_5_purchased
      FROM `project-bc6bbdcb-3ed5-46f0-be4.Yash.User_Event`
    )
SELECT *
FROM funnel_stage;

-- Conversion rates through the funnel

WITH
  Conversion_rates AS (
    SELECT
      COUNT(DISTINCT CASE WHEN event_type = "page_view" THEN user_id END)
        AS stage_1_views,
      COUNT(DISTINCT CASE WHEN event_type = "add_to_cart" THEN user_id END)
        AS stage_2_cart,
      COUNT(DISTINCT CASE WHEN event_type = "checkout_start" THEN user_id END)
        AS stage_3_checkout,
      COUNT(DISTINCT CASE WHEN event_type = "payment_info" THEN user_id END)
        AS stage_4_payment,
      COUNT(DISTINCT CASE WHEN event_type = "purchase" THEN user_id END)
        AS stage_5_purchased
    FROM `project-bc6bbdcb-3ed5-46f0-be4.Yash.User_Event`
  )
SELECT
  stage_1_views,
  stage_2_cart,
  round(stage_2_cart * 100 / stage_1_views) AS view_to_cart_rate,
  stage_3_checkout,
  round(stage_3_checkout * 100 / stage_2_cart) AS cart_to_checkout_rate,
  stage_4_payment,
  round(stage_4_payment * 100 / stage_3_checkout) AS checkout_to_payment_rate,
  stage_5_purchased,
  round(stage_5_purchased * 100 / stage_4_payment) AS payment_to_purchase_rate,
  round(stage_5_purchased * 100 / stage_1_views) AS overall_conv_rate
FROM Conversion_rates

-- funnel by source

with funnel_source as (
  select
  traffic_source,
  count(distinct case when event_type = "page_view" then user_id end) as views,
  count(distinct case when event_type = "add_to_cart" then user_id end) as carts,
  count(distinct case when event_type = "purchase" then user_id end) as purchases

  from `project-bc6bbdcb-3ed5-46f0-be4.Yash.User_Event`
  group by traffic_source
)
select 
traffic_source,
views,
carts,
purchases,
round(carts*100/views,1) as conversion_rate,
round(purchases*100/carts,1) as purchase_conversion_rate,
round(purchases*100/views,1) as cart_to_purchase_conversion_rate

from funnel_source
order by purchases desc;


-- time to conversion analysis

WITH
  user_journey AS (
    SELECT
      user_id,
      -- using min for 1st time for every user intraction 
      MIN(CASE WHEN event_type = "page_view" THEN event_date END) AS view_time,
      MIN(CASE WHEN event_type = "add_to_cart" THEN event_date END)
        AS cart_time,
      MIN(CASE WHEN event_type = "purchase" THEN event_date END)
        AS purchase_time
    FROM `project-bc6bbdcb-3ed5-46f0-be4.Yash.User_Event`
    GROUP BY user_id
    HAVING MIN(CASE WHEN event_type = "purchase" THEN event_date END)
      IS NOT NULL
  )
SELECT
  COUNT(*) AS converted_user,
  ROUND(AVG(TIMESTAMP_DIFF(cart_time, view_time, MINUTE)), 2)
    AS avg_view_to_cart_spend_in_minutes,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time, cart_time, MINUTE)), 2)
    AS avg_cart_to_purchase_minutes,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time, view_time, MINUTE)), 2)
    AS avg_total_journey_minutes
FROM user_journey;

-- Revenue funnel analysis
WITH 
  funnel_revenue as (
    select
      count(DISTINCT(CASE WHEN event_type = "page_view" THEN user_id END)) as Total_Visitor,
      COUNT(DISTINCT(CASE WHEN event_type = "purchase" THEN user_id END)) as Total_Purchases,
      ROUND(SUM(CASE WHEN event_type = "purchase" THEN amount END),2) as Total_Revenue,
      count(CASE WHEN event_type = "purchase" THEN 1 END ) as Total_Orders
      from `project-bc6bbdcb-3ed5-46f0-be4.Yash.User_Event`
  )
select 
Total_Visitor,
Total_Purchases,
Total_Revenue,
Total_Orders,
ROUND(Total_Revenue/Total_Orders,2) as Revenue_Per_Order,
ROUND(Total_Revenue/Total_Visitor,2) as Revenue_Per_Visitor,
ROUND(Total_Revenue/Total_Purchases,2) as Revenue_Per_Purchase,
from funnel_revenue

