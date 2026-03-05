# Swiggy Sales Analysis (SQL Project)

## Project Overview
This project analyzes Swiggy food delivery data to uncover insights related to customer demand, restaurant performance, pricing patterns, and geographic contribution.  

The dataset contains **197K+ food delivery transactions** across multiple cities, restaurants, cuisines, and dishes. The goal is to transform raw operational data into actionable business insights that can support decision-making for marketing, operations, and restaurant partnerships.

---

## Business Problem
Food delivery platforms operate across thousands of restaurants and cities, making it difficult to identify high-demand markets, popular cuisines, and customer spending patterns.  

Without structured analysis, it becomes challenging to:
- Understand which locations drive the most orders
- Identify top-performing restaurants and dishes
- Analyze customer spending behavior
- Track demand trends over time

This project aims to solve these challenges using **SQL-based data cleaning, data modeling, and business analysis**.

---

## Data Cleaning & Validation
The raw dataset contained several data quality issues that could affect analysis.

Key data cleaning steps performed:
- Checked for **null values** in important attributes such as city, restaurant, dish, price, and ratings
- Identified **blank or empty string records**
- Detected **duplicate rows using ROW_NUMBER()**
- Removed duplicate records to ensure **accurate analytics**

This ensured a **clean and reliable dataset for business insights**.

---

## Data Modeling (Star Schema)
To optimize analytical queries, the dataset was transformed into a **Star Schema**.

### Fact Table
- `fact_swiggy_orders`

### Dimension Tables
- `dim_date`
- `dim_location`
- `dim_restaurant`
- `dim_category`
- `dim_dish`

This structure improves:
- Query performance
- Reporting efficiency
- Analytical scalability

---

## Key Performance Indicators (KPIs)

The following KPIs were developed to measure platform performance:

- Total Orders
- Total Revenue (INR Million)
- Average Dish Price
- Average Rating

These KPIs provide a high-level overview of the platform's performance.

---

## Business Insights

### Location Performance
Analysis showed that **top 10 cities contribute approximately 60% of total orders**, indicating major demand hubs where delivery infrastructure and marketing campaigns should be prioritized.

### Restaurant Performance
Restaurant-level analysis revealed that **top-performing restaurants generate around 40% of total platform revenue**, highlighting strong customer preference for certain restaurant brands.

### Customer Spending Behavior
Customer spend segmentation across **five pricing tiers (₹100–₹500+)** revealed that **₹100–₹299 orders account for nearly 55% of total transactions**, indicating strong demand for mid-priced meals.

### Demand Trends
Time-based analysis identified peak ordering days contributing **20–25% higher order volume**, providing insights for delivery workforce planning and promotional timing.

---

## Tools & Technologies
- SQL (MySQL)
- Data Cleaning & Validation
- Dimensional Modeling (Star Schema)
- Business KPI Development
- Analytical Querying

---

## Project Outcome
This project demonstrates how structured data analysis can help food delivery platforms:

- Identify high-demand markets
- Optimize restaurant partnerships
- Understand customer spending behavior
- Improve operational planning

By leveraging SQL and data modeling techniques, raw transactional data was converted into **actionable business insights**.
