create database project
select * from [dbo].[WalmartSalesData.csv] 

-----feature engineering----
select time,
case
when time between '00:00:00' and '12:00:00' then 'Morning'
when time between '12:01:00' and '16:00:00' then 'Afternoon'
else 'Evening'
end as time_of_day
from [dbo].[WalmartSalesData.csv] 

alter table [dbo].[WalmartSalesData.csv] 
add TIME_OF_DAY VARCHAR(20)


update [dbo].[WalmartSalesData.csv] set
time_of_day=
case
when time between '00:00:00' and '12:00:00' then 'Morning'
when time between '12:01:00' and '16:00:00' then 'Afternoon'
else 'Evening'
end
from [dbo].[WalmartSalesData.csv] 


alter table [dbo].[WalmartSalesData.csv] 
add day_name varchar(10)

update [dbo].[WalmartSalesData.csv] set
day_name=datename(weekday,date) from [dbo].[WalmartSalesData.csv] 

alter table [dbo].[WalmartSalesData.csv] 
add month_name varchar(20)

update [dbo].[WalmartSalesData.csv]  set
month_name=datename(month,date) from [dbo].[WalmartSalesData.csv] 

select * from [dbo].[WalmartSalesData.csv] 


---Generic Question---
--How many unique cities does the data have?
select distinct city from [dbo].[WalmartSalesData.csv]


--In which city is each branch? 
select branch,city from [dbo].[WalmartSalesData.csv]
group by branch,city



---Product---

--1.How many unique product lines does the data have?
select count(distinct product_line) from [dbo].[WalmartSalesData.csv]


--2.What is the most common payment method?
select payment,count(payment) as most_paymethod from [dbo].[WalmartSalesData.csv]
group by payment
order by most_paymethod desc

---3.What is the most selling product line?

select product_line,count(product_line) as cnt from [dbo].[WalmartSalesData.csv]
group by product_line
order by cnt desc


--What is the total revenue by month?
select month_name,sum(total) as total from [dbo].[WalmartSalesData.csv] group by
month_name

--What month had the largest COGS?
select * from [dbo].[WalmartSalesData.csv]

select month_name,sum(cogs) as max_cogs from [dbo].[WalmartSalesData.csv]
group by month_name
order by max_cogs desc

--What product line had the largest revenue?
select * from [dbo].[WalmartSalesData.csv]

select product_line,sum(total) as revenue from [dbo].[WalmartSalesData.csv]
group by product_line
order by revenue desc

--What is the city with the largest revenue?
select city,sum(total) as total from [dbo].[WalmartSalesData.csv]
group by city
order by total desc


--What product line had the largest VAT?
select product_line,avg(tax_5) as total from [dbo].[WalmartSalesData.csv]
group by product_line
order by total desc
select * from [dbo].[WalmartSalesData.csv]


--Fetch each product line and add a column to those product line showing "Good", "Bad". 
--Good if its greater than average sales
select product_line,
case
when total>avg(total) then 'good'
else 'bad'
end as avg_sales
from [dbo].[WalmartSalesData.csv]
group by product_line,avg_sales


--Which branch sold more products than average product sold?
select branch,sum(quantity) as  cnt from
[dbo].[WalmartSalesData.csv]
group by branch
having sum(quantity)>(select avg(quantity) from [dbo].[WalmartSalesData.csv])


--What is the most common product line by gender?
select * from [dbo].[WalmartSalesData.csv]
select gender,product_line,count(product_line)as cnt from [dbo].[WalmartSalesData.csv]
group by gender,product_line
order by cnt desc


--What is the average rating of each product line?
select product_line,avg(rating) as avg_rating
from [dbo].[WalmartSalesData.csv]
group by product_line
order by avg_rating desc



--Sales
--Number of sales made in each time of the day per weekday
select time_of_day,count(*) as total_sales from [dbo].[WalmartSalesData.csv]
where day_name='Monday'
group by time_of_day


--Which of the customer types brings the most revenue?
select customer_type,sum(total)as highest_revenue from
[dbo].[WalmartSalesData.csv] group by customer_type
order by highest_revenue desc


--Which city has the largest tax percent/ VAT (Value Added Tax)?

 select city,max(tax_5) as largest_tax from
 [dbo].[WalmartSalesData.csv]
 group by city


--Which customer type pays the most in VAT?

 select customer_type,sum(tax_5) as high_tax from
 [dbo].[WalmartSalesData.csv]
 group by customer_type
 order by high_tax desc


--Customer
--How many unique customer types does the data have?
 select * from [dbo].[WalmartSalesData.csv]
 select distinct customer_type from [dbo].[WalmartSalesData.csv]

--How many unique payment methods does the data have?
select distinct payment from [dbo].[WalmartSalesData.csv]


---What is the most common customer type?
 select customer_type from [dbo].[WalmartSalesData.csv]
 group by customer_type


--Which customer type buys the most?
select customer_type,count(quantity) as most_buy from [dbo].[WalmartSalesData.csv]
group by customer_type

---What is the gender of most of the customers?

select gender,count(*) as cnt from [dbo].[WalmartSalesData.csv]
group by gender
order by cnt desc


--What is the gender distribution per branch?

select gender,branch,count(*) as cnt from [dbo].[WalmartSalesData.csv]
group by gender,branch


--Which time of the day do customers give most ratings
 select avg(rating) as total_rating,time_of_day from [dbo].[WalmartSalesData.csv]
 group by time_of_day
 order by total_rating desc


--Which time of the day do customers give most ratings per branch?
 select avg(rating) as total_rating,time_of_day from [dbo].[WalmartSalesData.csv]
 where branch='B'
 group by time_of_day
 order by total_rating desc


---Which day of the week has the best avg ratings?
 select * from [dbo].[WalmartSalesData.csv]
 select day_name,avg(rating) as avg_rating from [dbo].[WalmartSalesData.csv]
 group by day_name
 order by avg_rating desc

---Which day of the week has the best average ratings per branch?
 select day_name,avg(rating) as avg_rating from [dbo].[WalmartSalesData.csv]
 where branch='A'
 group by day_name
 order by avg_rating desc