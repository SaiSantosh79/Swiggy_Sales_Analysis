create database Swiggy_DB;
use Swiggy_DB;
show tables;
select count(*) from Swiggy_orders;
select * from swiggy_orders;
drop database swiggy_db;
desc swiggy_data;

create table swiggy_orders(
State	varchar(100),
City	varchar(100),
Order_Date	date,
Restaurant_Name	varchar(150),
Location varchar(100),
Category varchar(100),
Dish_Name varchar(200),
Price_inr int,
Rating	varchar(100),
Rating_Count smallint);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 
'C:/Users/santo/Downloads/Swiggy_Data.csv'
INTO TABLE swiggy_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SHOW VARIABLES LIKE 'secure_file_priv';
-- Checking Data Labels And data types
alter table swiggy_data
rename column ï»¿State to state;

ALTER TABLE swiggy_data
change column Order_Date Order_Date Date ;

UPDATE swiggy_orders
SET Rating = NULL
WHERE Rating IN ('NEW','--','NaN');

ALTER TABLE swiggy_orders
MODIFY Rating DOUBLE;

-- data validation and cleaning
-- null check
select
	sum(case when state is null then 1 else 0 end) as null_state,
    sum(case when city is null then 1 else 0 end) as null_city,
    sum(case when Order_Date is null then 1 else 0 end) as null_order_date,
    sum(case when restaurant_name  is null then 1 else 0 end) as null_Restaurant,
    sum(case when location is null then 1 else 0 end) as NUll_location,
    sum(case when category is null then 1 else 0 end) as null_category,
    sum(case when dish_name is null then 1 else 0 end) as Null_name,
    sum(case when price_inr is null then 1 else 0 end) as NUll_price,
    sum(case when Rating is null then 1 else 0 end) as null_rating,
    sum(case when rating_count is null then 1 else 0 end) as null_count
from swiggy_orders;

-- Blank or empty strings
select * from swiggy_orders
where state='' or city='' or rating='' or restaurant_name='' or location='' or category=''
or dish_name='';

-- Duplicate detection
   select count(*) 
   from (
   SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY state, city, order_date, restaurant_name,
                            location, category, dish_name,
                            price_inr, rating, rating_count
               ORDER BY state
           ) AS rn
    FROM swiggy_orders
    )t
WHERE rn > 1;

-- Duplicate Deletion
WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY state, city, order_date, restaurant_name,
               location, category, dish_name, price_inr, rating, rating_count
           ) AS rn
    FROM swiggy_orders
)

DELETE FROM swiggy_orders
WHERE order_date IN (
    SELECT order_date
    FROM cte
    WHERE rn > 1
);

select count(*) from swiggy_orders;

-- create schema
-- Dimensions table
-- date table

create table dim_date(
	date_id int auto_increment primary key,
    full_date  date,
    Year int,
    Month int,
    Month_name Varchar(20),
    Quarter int,
    Day int,
    week int);
    
select * from dim_date;

-- dim_location
create table dim_location (
	location_id int auto_increment primary key,
    state varchar(100),
    city varchar(100),
    location varchar(100));
    
select * from dim_location;

create table dim_restaurant (
	restaurant_id int auto_increment primary key,
    restaurant_name varchar(200));

select * from dim_restaurant;

create table dim_category (
	category_id int auto_increment primary key,
    category varchar(200));

select * from dim_category;

create table dim_dish (
	dish_id int auto_increment primary key,
    dish_name varchar(200));
    
select * from dim_dish;


-- creation FACT Table
create table Main_Swiggy_Orders(
	order_id int auto_increment primary key,
    date_id int,
    price_inr decimal(10,2),
    rating decimal (4,2),
    rating_count int,
    location_id int,
    restaurant_id int,
    category_id int,
    dish_id int,
    
    foreign key(date_id) references dim_date(date_id),
    foreign key(location_id) references dim_location(location_id),
    foreign key(restaurant_id) references dim_restaurant(restaurant_id),
    foreign key(category_id) references dim_category(category_id),
    foreign key(dish_id) references dim_dish(dish_id));
    
select * from main_swiggy_orders;

-- insert values in the tables
INSERT INTO dim_date 
(full_date, year, month, month_name, quarter, day, week)
SELECT DISTINCT
order_date,
YEAR(order_date),
MONTH(order_date),
MONTHNAME(order_date),
QUARTER(order_date),
DAY(order_date),
WEEK(order_date)
FROM swiggy_orders
WHERE order_date IS NOT NULL;

select * from dim_date;

-- dim_location
INSERT INTO dim_location (State, City, Location)
SELECT DISTINCT
State,
City,
Location
FROM swiggy_orders;

select * from dim_location;

-- dim_restaurant
INSERT INTO dim_restaurant( Restaurant_Name)
SELECT DISTINCT
Restaurant_Name
FROM swiggy_orders;

select * from dim_restaurant;

-- dim_category
INSERT INTO dim_category (Category)
SELECT DISTINCT
Category
FROM swiggy_orders;

select * from dim_category;

-- dim_dish
INSERT INTO dim_dish (Dish_Name)
SELECT DISTINCT
Dish_Name
FROM swiggy_orders;

select * from dim_dish;

-- fact_table
INSERT INTO main_swiggy_orders
(
date_id,
price_inr,
rating,
rating_count,
location_id,
restaurant_id,
category_id,
dish_id
)
SELECT
dd.date_id,
s.price_inr,
s.rating,
s.rating_count,
dl.location_id,
dr.restaurant_id,
dc.category_id,
dsh.dish_id
FROM swiggy_orders s

JOIN dim_date dd
ON dd.full_date = s.order_date

JOIN dim_location dl
ON dl.state = s.state 
AND dl.city = s.city 
AND dl.location = s.location

JOIN dim_restaurant dr
ON dr.restaurant_name = s.restaurant_name

JOIN dim_category dc
ON dc.category = s.category

JOIN dim_dish dsh
ON dsh.dish_name = s.dish_name;

select * from main_swiggy_Orders;

select * from main_swiggy_Orders f
join dim_date d on f.date_id = d.date_id
join dim_location l on f.location_id = l.location_id
join dim_restaurant r on f.restaurant_id = r.restaurant_id
join dim_category c on f.category_id = c.category_id
join dim_dish di on f.dish_id = di.dish_id;

-- KPI"s
-- Total Orders
select count(*) as total_orders from main_swiggy_orders;

-- Total Revenue (INR Million)
SELECT 
CONCAT(
FORMAT(SUM(price_inr) / 1000000, 2),
' INR Million'
) AS total_revenue
FROM main_swiggy_orders;

-- AVG dish Price
select  concat(format(avg(price_inr),2),'INR') as Avg_dish_Price from main_swiggy_orders;

-- AVG Rating
select concat(format(avg(rating),1)) as avg_rating from main_swiggy_orders;

-- deep-dive business analysis
-- monthly sales trends
select d.year,d.month,d.month_name,count(*) as total_orders
,sum(price_inr) as total_revenue from
main_swiggy_orders f join dim_date d 
on d.date_id=f.date_id
group by d.year,d.month,d.month_name
order by sum(price_inr) desc;

-- Quarter sales trends
select d.year,d.quarter,d.month_name,count(*) as total_orders,
sum(price_inr) as total_revenue from main_swiggy_orders as f
join dim_date d on d.date_id=f.date_id
group by d.year,d.quarter,d.month_name
order by total_revenue desc;

-- Year sales Trends
select d.year,count(*) as total_orders,sum(price_inr) as total_revenue 
from main_swiggy_orders f join dim_date d
on f.date_id=d.date_id
group by d.year
order by total_revenue desc;

-- Orders by day of week (mon-sum)
select dayname(d.full_date),d.day,count(*) as total_orders,
sum(price_inr) as total_revenue
from main_swiggy_orders s
join dim_date d on s.date_id=d.date_id
group by dayname(d.full_date),d.day
order by total_orders desc;

-- Loction_Based Analysis
-- Top 10 cities by order volume
select l.city,count(*) as total_orders from main_swiggy_orders m
join dim_location l on l.location_id=m.location_id
group by l.city
order by total_orders desc
limit 10;

-- Revenuve Contribution By states
select sum(price_inr) as total_revenue,l.state from main_swiggy_orders m
join dim_location l on m.location_id=l.location_id
group by state;

-- Food Performance
-- Top 10  Restaurants by orders
select restaurant_name,count(*) as total_orders,sum(price_inr) as total_revenue
 from main_swiggy_orders m join dim_restaurant r
 on m.restaurant_id=r.restaurant_id group by restaurant_name
 order by total_revenue desc
 limit 10;

-- Top categories 
select category,count(*) as total_orders,sum(price_inr) as total_revenue
 from main_swiggy_orders m join dim_category c
 on m.category_id=c.category_id group by category
 order by total_revenue desc ;
 
 -- Most Ordered dishes
select dish_name,count(*) as  most_ordered from main_swiggy_orders m
join dim_dish d on m.dish_id=d.dish_id
 group by dish_name order by most_ordered desc;
 
 -- cusine performance
 select format(rating,1) rating,concat(format(avg(rating),1)) 
 avg_rating,count(*) as total_orders from main_swiggy_orders
 group by rating order by total_orders desc;
 
-- Customer Spending Insights
SELECT 
CASE 
    WHEN price_inr < 100 THEN 'Under 100'
    WHEN price_inr BETWEEN 100 AND 199 THEN '100-199'
    WHEN price_inr BETWEEN 200 AND 299 THEN '200-299'
    WHEN price_inr BETWEEN 300 AND 399 THEN '300-399'
    WHEN price_inr BETWEEN 400 AND 499 THEN '400-499'
    ELSE '500+'
END AS customer_spend_scale,
COUNT(*) AS total_orders
FROM main_swiggy_orders
GROUP BY customer_spend_scale
ORDER BY total_orders DESC;

-- Rating Analysis
select d.dish_name,m.rating from main_swiggy_orders m
left join dIm_dish d on d.dish_id=m.dish_id
group by d.dish_name,m.rating;








