use ecommerce_data

select * from ecommerce_customer_data limit 5


-- What is The Total Customers vs Churn rate
select count(*) as total_customers,sum(churned) as churned_customers,
round(100.0*sum(churned)/count(*),2) as churn_percent
from ecommerce_customer_data

-- Average Customer Lifetime Value

select round(avg(lifetime_value),2) as avg_lifetime_value from ecommerce_customer_data

-- Churned vs retained

select churned,round(avg(lifetime_value),2) as avg_ltv
from ecommerce_customer_data
group by churned


-- Never Purchased Churned
select count(*) as churned_no_purchase
from ecommerce_customer_data
where total_purchases =0
and churned =1

-- Active Vs Inactive Churn
select activity_status,count(*) as customers,
round(100.0* sum(churned)/count(*),2) as churn_rate
from ecommerce_customer_data
group by activity_status

-- High Value Customer Who Churned

select count(*) as high_value_churned_customers
from ecommerce_customer_data where value_segment='High Value' and churned =1

-- Revenue Risk Due To Churn
select
round(sum(lifetime_value),2) as revenue_at_risk
from ecommerce_customer_data where churned=1

-- Churn Trend By Signup Quarter

select signup_quarter,
round(100.0* sum(churned)/count(*),2) as churn_rate
from ecommerce_customer_data
group by signup_quarter
order by signup_quarter

-- Cart Abandon Rate Based on Gender

select distinct gender ,round(avg(cart_abandonment_rate) over(partition by gender),2)
from ecommerce_customer_data

-- Return rate Vs Total Purchases

select churned,
case 
when total_purchases =0 then 'No Purchase'
when total_purchases between 1 and 5 then 'Low Purchases'
when total_purchases between 6 and 15 then 'Medium Purchases'
else 'High Purchases' end as purchase_segment,
round(avg(returns_rate),3) as avg_returns_rate,
count(*) as customers
from ecommerce_customer_data
group by churned,purchase_segment
order by churned,avg_returns_rate desc