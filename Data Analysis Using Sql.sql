




select * from df_orders;

--find top 10 highest reveue generating products 

select top 10 Product_id,sum(sales_price) as revenue
from df_orders
group by product_id
order by sum(sales_price) desc ;

--find top 5 highest selling products in each region

with cts as (
select product_id,sum(sales) as sales,region,ROW_NUMBER() over(partition by region  order by sum(sales) desc) as row_no
from df_orders
group by product_id,region)
select * from cts
where row_no<=5;


--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023

select * from df_orders;


with cte as (
select year(order_date) as order_year,month(order_date) as order_month,
sum(sales_price) as sales
from df_orders
group by year(order_date),month(order_date)
--order by year(order_date),month(order_date)
	)
select order_month
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by order_month
order by order_month

--for each category which month had highest sales
with cte as (
select category,format(order_date,'yyyyMM') as order_year_month, ROW_NUMBER() over(partition by category order by sum(sales)  desc) as row_no
, sum(sales) as sales 
from df_orders
group by category,format(order_date,'yyyyMM') )
select category, order_year_month ,sales from
cte
where row_no=1;

--which sub category had highest growth by profit in 2023 compare to 2022
select * from df_orders;
with cts as(
select sub_category,sum(sales) as sales,year(order_date) as year from
df_orders
group by sub_category,year(order_date)),
cts2 as(
select sub_category,
sum(case when year=2022 then sales else 0 end) as year_2022,
sum(case when year=2023 then sales else 0 end) as year_2023
from cts
group by sub_category)
select top 1 *,
(year_2023-year_2022) as highest_salary
from cts2
order by (year_2023-year_2022) desc







--select 
