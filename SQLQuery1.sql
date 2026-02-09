-- Created by GitHub Copilot in SSMS - review carefully before executing

-- A. KPIs
-- 1. Total Revenue
SELECT CAST(SUM(total_price) AS DECIMAL(10,2)) AS TotalRevenue
FROM dbo.pizza_sales;

-- 2. Average Order Value
SELECT CAST(SUM(total_price) / NULLIF(COUNT(DISTINCT order_id), 0) AS DECIMAL(10,2)) AS AverageOrderValue
FROM dbo.pizza_sales;

-- 3. Total Pizzas Sold
SELECT SUM(quantity) AS TotalPizzasSold
FROM dbo.pizza_sales;

-- 4. Total Orders
SELECT COUNT(DISTINCT order_id) AS TotalOrders
FROM dbo.pizza_sales;

-- 5. Average Pizzas per Order (2 decimal places)
SELECT CAST(SUM(quantity) * 1.0 / NULLIF(COUNT(DISTINCT order_id), 0) AS DECIMAL(10,2)) AS AvgPizzasPerOrder
FROM dbo.pizza_sales;

-- B. Daily trend for total orders (day name)
SELECT DATENAME(weekday, order_date) AS DayName,
       COUNT(DISTINCT order_id) AS TotalOrders
FROM dbo.pizza_sales
GROUP BY DATENAME(weekday, order_date)
ORDER BY DATEPART(weekday, MIN(order_date));

-- C. Monthly trend for total orders (month name)
SELECT DATENAME(month, order_date) AS MonthName,
       COUNT(DISTINCT order_id) AS TotalOrders
FROM dbo.pizza_sales
GROUP BY DATENAME(month, order_date)
ORDER BY DATEPART(month, MIN(order_date));

-- D. Percentage of sales by pizza category
SELECT pizza_category AS Category,
       CAST(SUM(total_price) AS DECIMAL(10,2)) AS CategoryRevenue,
       CAST(100.0 * SUM(total_price) / NULLIF(SUM(SUM(total_price)) OVER (), 0) AS DECIMAL(10,2)) AS RevenuePercent
FROM dbo.pizza_sales
GROUP BY pizza_category
ORDER BY RevenuePercent DESC;

-- E. Percentage of sales by pizza size (ordered by size)
SELECT pizza_size AS Size,
       CAST(SUM(total_price) AS DECIMAL(10,2)) AS SizeRevenue,
       CAST(100.0 * SUM(total_price) / NULLIF(SUM(SUM(total_price)) OVER (), 0) AS DECIMAL(10,2)) AS RevenuePercent
FROM dbo.pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;

-- F. Total pizzas sold by category for February
SELECT pizza_category AS Category,
       SUM(quantity) AS TotalPizzasSold
FROM dbo.pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY TotalPizzasSold DESC;

-- G. Top 5 pizzas by revenue
SELECT TOP (5) pizza_name AS PizzaName,
       CAST(SUM(total_price) AS DECIMAL(10,2)) AS TotalRevenue
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY TotalRevenue DESC;

-- H. Bottom 5 pizzas by revenue
SELECT TOP (5) pizza_name AS PizzaName,
       CAST(SUM(total_price) AS DECIMAL(10,2)) AS TotalRevenue
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY TotalRevenue ASC;

-- I. Top 5 pizzas by quantity
SELECT TOP (5) pizza_name AS PizzaName,
       SUM(quantity) AS TotalQuantity
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY TotalQuantity DESC;

-- J. Bottom 5 pizzas by quantity
SELECT TOP (5) pizza_name AS PizzaName,
       SUM(quantity) AS TotalQuantity
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY TotalQuantity ASC;

-- K. Top 5 pizzas by total orders
SELECT TOP (5) pizza_name AS PizzaName,
       COUNT(DISTINCT order_id) AS TotalOrders
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY TotalOrders DESC;

-- L. Bottom 5 pizzas by total orders
SELECT TOP (5) pizza_name AS PizzaName,
       COUNT(DISTINCT order_id) AS TotalOrders
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY TotalOrders ASC;