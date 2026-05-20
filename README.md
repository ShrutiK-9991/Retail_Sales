# Retail Sales Analysis 

## Project Overview
This project performs an end-to-end SQL-based analysis of a retail sales dataset using **PostgreSQL 18**. It covers database creation, data cleaning, and answering 10 real-world business questions through structured SQL queries. The goal is to extract actionable insights from transactional retail data to support business decision-making.

## Objectives
- Design and create a relational database schema for retail sales data
- Perform data cleaning to ensure accuracy and completeness
- Analyse sales trends across time, product categories, and customer demographics
- Identify top-performing customers, categories, and time periods

## Database Setup

## Schema
```sql
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
```

## Data Cleaning

### Initial Exploration

1. Preview first 10 records
   ```sql
   SELECT * from retail_sales limit 10;
   ```
2. Count total records
   ```sql
   select count(*) from retail_sales;
   ```

### Null Value Checks
```sql
SELECT * from retail_sales 
where transactions_id is null;

SELECT * from retail_sales 
where sale_date is null;
```

### Remove Incomplete Records
```sql
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
```

-- All Analysis is performed on complete, clean records only.

## Data Analysis — Business Questions & Queries

3. Write SQL query to retreive all columns for sales made on 2022-11-05?
   ```sql
   select * from retail_sales where sale_date = '2022-11-05';
   ```
4. Write SQL query to retreive all transactions where the category is 'Clothing' and the quantity sold is less than 4 in the month of Nov-2022?
   ```sql
   select category, quantity, sale_date from retail_sales where category = 'Clothing' and to_char(sale_date, 'YYYY-MM') = '2022-11' and quantity <= 4;
   ```
5. Write a SQL query to calculate the total sales (total_sale) for each category?
   ```sql
   select category, sum(total_sale) as total_sales from retail_sales group by category;
   ```
6. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?
   ```sql
   select category, avg(age) as "average_age" from retail_sales where category = 'Beauty' group by category;
   select category, round(avg(age), 2) as "average_age" from retail_sales where category = 'Beauty' group by category;
   ```
7. Write a SQL query to find all transactions where the total_sale is greater than 1000?
   ```sql
   select * from retail_sales where total_sale > 1000;
   select count(total_sale) from retail_sales where total_sale > 1000;
   ```
8. Write a SQL query to find the total number of transactions (transaction_id) made by gender in each category?
   ```sql
   select category, gender, count(transactions_id) as "total_trans" from retail_sales group by category, gender order by category;
   ```
9. Write a SQL query to calculate the average sale for each month. Find the best selling month in each year?
    ```sql
    select * from
   (
	    select 
		    extract(year from sale_date) as "year", 
		    extract(month from sale_date) as "month", 
		    round(avg(total_sale), 2) as "avg_sale", 
		    rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
		    from retail_sales 
		    group by 1, 2
   )as t1
        where rank = 1;
    ```
10. Write a SQL query to find the top 5 customers based on the highest total sales?
    ```sql
    select 
	customer_id, 
	sum(total_sale) as "total_sales" 
	from retail_sales 
	group by customer_id 
	order by 2 desc
	limit 5;
    ```
11. Write a SQL query to find the number of unique customers who purchased items from each category?
    ```sql
    select 
	count(distinct customer_id) as unique_customers,
	category
	from retail_sales
	group by category;
    ```
12. Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening > 17)?
    ```sql
    select *,
	      CASE
		        when extract(hour from sale_time) < 12 then 'Morning'
		        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		        else 'Evening'
	      end as "shift"
    from retail_sales;


## Key Insights
- **Customer Demographics:** The average age of Beauty category shoppers gives insight into target demographics for personalised campaigns.
- **High-Value Sales:** Filtering transactions above 1000 highlights premium purchases and loyal big spenders.
- **Gender Trends:** Transaction counts by gender per category uncover purchasing preferences across male and female customers.
- **Seasonal Trends:** The best-selling month analysis (Q.9) identifies peak revenue months each year, useful for inventory and staffing planning.
- **Top Customers:** The top 5 customers by revenue are strong candidates for loyalty rewards or VIP programmes.
- **Shift Analysis:** Classifying transactions by time of day (Morning/Afternoon/Evening) reveals when customers shop most, enabling optimised staffing and promotions.


## Conclusions
This project demonstrates how SQL can be used to clean raw retail data and derive meaningful business insights without any external tools. Key takeaways include:

1. **Data quality is critical** — removing null records ensures analysis reliability.
2. **Window functions** (like `RANK()`) are powerful for time-based performance comparisons.
3. **Shift-based analysis** can directly inform operational decisions like staffing and flash-sale timing.

## Tools Used
- **PostgreSQL 18**
- **pgAdmin** (Query Editor)
- **SQL** — DDL, DML, Aggregations, Window Functions, CASE statements













