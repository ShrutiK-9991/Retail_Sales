-- SQL Retail Sales Analysis -1

-- CREATE TABLE
drop table if exists retail_sales; 
create table retail_sales
(
	transactions_id	   INT PRIMARY KEY,
	sale_date	       DATE ,
	sale_time	       TIME ,
	customer_id	       INT ,
	gender	           VARCHAR(15) ,
	age	               INT ,
	category	       VARCHAR(50) ,
	quantity	       INT ,
	price_per_unit	   FLOAT ,
	cogs	           FLOAT , --cogs means purchasing cost
	total_sale         INT
);

SELECT * from retail_sales limit 10;

select count(*) from retail_sales;

-- DATA CLEANING
SELECT * from retail_sales 
where transactions_id is null;

SELECT * from retail_sales 
where sale_date is null;

SELECT * from retail_sales 
where 
	transactions_id is null
	OR
	sale_date is null
	OR
	sale_time is null
	OR
	gender is null
	OR
	category IS NULL
	OR
	quantity is null
	OR
	price_per_unit is null
	OR
	cogs is null
	OR
	total_sale is null;

----------

delete from retail_sales
where 
	transactions_id is null
	OR
	sale_date is null
	OR
	sale_time is null
	OR
	gender is null
	OR
	category IS NULL
	OR
	quantity is null
	OR
	price_per_unit is null
	OR
	cogs is null
	OR
	total_sale is null;


-- DATA EXPLORATION

-- How many sales we have?
select count(*) total_sale from retail_sales;

-- How many unique customers we have?
select count(distinct customer_id) from retail_sales;

-- How to display unique categori that we have?
select distinct customer_id,category from retail_sales;

-- How many unique categories we have?
select count(distinct category) from retail_sales;

-- How to display unique categories that we have?
select distinct category from retail_sales;

-- 	QUESTIONS 
-- Q.1 Write SQL query to retreive all columns for sales made on 2022-11-05?
select * from retail_sales where sale_date = '2022-11-05';
select count(*) from retail_sales where sale_date = '2022-11-05';

-- Q.2 Write SQL query to retreive all transactions where the category is 'Clothing' and the quantity sold is less than 4 in the month of Nov-2022?
select category, quantity, sale_date from retail_sales where category = 'Clothing' and to_char(sale_date, 'YYYY-MM') = '2022-11' and quantity <= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category?
select category, sum(total_sale) as total_sales from retail_sales group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?
select category, avg(age) as "average_age" from retail_sales where category = 'Beauty' group by category;
select category, round(avg(age), 2) as "average_age" from retail_sales where category = 'Beauty' group by category;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000?
select total_sale from retail_sales where total_sale > 1000;
select count(total_sale) from retail_sales;
select count(total_sale) from retail_sales where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by gender in each category?
select category, gender, count(transactions_id) as "total_trans" from retail_sales group by category, gender order by category; 

-- Q.7 Write a SQL query to calculate the average sale for each month. Find the best selling month in each year?
select * from
(
	select 
		extract(year from sale_date) as "year", 
		extract(month from sale_date) as "month", 
		round(avg(total_sale), 2) as "avg_sale", 
		rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
		from retail_sales 
		group by 1, 2
) as t1
where rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales?
select 
	customer_id, 
	sum(total_sale) as "total_sales" 
	from retail_sales 
	group by customer_id 
	order by 2 desc
	limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category?
select 
	count(distinct customer_id) as unique_customers,
	category
	from retail_sales
	group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening > 17)?
select *,
	CASE
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as "shift"
from retail_sales;