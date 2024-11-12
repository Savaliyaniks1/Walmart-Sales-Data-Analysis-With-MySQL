create database if not exists walmartsales;

create table if not exists sales(
	invoice_id varchar(30) NOT NULL PRIMARY KEY,
	branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12, 4),
    rating FLOAT
);

select * from sales;

-- FEATURE ENGINEERING

-- TIME

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (
	case
         when 'time' between "00:00:00:" and "12:00:00" then "Morning"
         when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
         else "Evening"
	 end
);

select * from sales;


-- DAY NAME

alter table sales add column day_name varchar(10);

update sales set day_name = dayname(date);

select * from sales;

-- MONTH NAME

ALTER TABLE sales add column month_name varchar(10);

update sales
set month_name = monthname(date);

select * from sales;
--------------------- generic questions ------------------------------
-- How many unique cities does the data have?

select distinct city from sales;

-- In which city is each branch ?

select distinct city,branch from sales;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------
-- how many unique product line does the data have?

select count(distinct product_line)
from sales;

-- what is the most common payment method?

select payment,count(payment) as cnt from sales 
group by payment
order by cnt desc;

-- what is the most top 5 selling product line?

select product_line,count(product_line) as top_selling_product from sales
group by product_line
order by top_selling_product 
desc limit 5;

-- what is the total revenue by month?

select month_name as month,
round(sum(total),2) as total_revenue
 from sales
 group by month_name
 order by total_revenue
 desc;

-- What month had the largest COGS

select month_name as month,max(cogs) as total_COGS 
from sales
group by month_name
order by total_cogs desc;

-- what product line had the largest revenue?

select product_line,sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- what is the city with the largest revenue?

select branch,city,sum(total) as total_revenue
from sales
group by city,branch
order by total_revenue desc;

-- what product line had the largest tax?

select product_line,round(avg(tax_pct),2) as total_tax 
from sales
group by product_line
order by total_tax desc;

-- fetch each product line and add a column to those product line showing "good","bad",good if it is better than average sales.
select product_line,
     case 
        when avg(total)>(select avg(total)from sales) then "Good"
	 else "Bad"
     end as reamrk
from sales
group by product_line;

-- which branch sold more product than average product sold?

select branch,sum(quantity) as qty
from sales
group by branch
having sum(quantity)>(select avg(quantity) from sales);

-- what is the most common product line by gender

select product_line,gender,count(gender) as total_cnt
from sales
group by product_line,gender
order by total_cnt desc;

-- what is the average rating of each product line?

select product_line,round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating desc;

-- number of sales made in each time of the day per weekday

select time_of_day,count(*) as total_sales
from sales
where day_name = "Monday"
group by time_of_day;


-- which of the customer types brings the most revenue?

select customer_type,round(sum(total),2) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

-- which city has the largest tax percent/ VAT (value added tax)?

select city,round(avg(tax_pct),2) as VAT
from sales
group by city
order by VAT desc;

-- which customer type pays the most in VAT ?

select customer_type,round(avg(tax_pct),2) as VAT
from sales
group by customer_type
order by VAT desc;


-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- how many unique customer types does the data have?

select distinct customer_type from sales;

-- how many unique payment methods does the data have?

select distinct payment from sales;

-- which customer type buy most?

select customer_type,count(*) as CNT
from sales
group by customer_type
order by CNT desc;

-- what is the gender of the most of the customer?

select gender,count(*) as CNT_gender
from sales
group by gender
order by CNT_gender desc;

 -- what is the gender distribution per branch?
 
 select gender,count(*) as CNT
from sales
where branch = "c"
group by gender
order by CNT desc;

-- which day of the week has the best avg ratings?

select day_name,round(avg(rating),2) as Rating
from sales
group by day_name
order by rating desc;


-- which day of the week has the best avg ratings per branch?

select day_name,round(avg(rating),2) as Rating
from sales
where branch = "A"
group by day_name
order by rating desc;


-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;


-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;