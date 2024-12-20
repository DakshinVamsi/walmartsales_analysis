USE walmart_db;

SELECT * FROM walmart;

SELECT payment_method,COUNT(*) AS 'Total', payment_method FROM walmart
GROUP BY payment_method ;

-- Business Problems 

-- Finding the no of transactions and quantities sold for each mode of payment 

SELECT payment_method,COUNT(*) AS 'Transactions' , SUM(quantity) as 'Total Quantity' FROM walmart
GROUP BY payment_method;

-- Identify the highest rated category in each branch ; Display the branch,category and the average rating

SELECT * FROM walmart;


 SELECT * 
 FROM 
 
(SELECT 
Branch,
category,
AVG(rating) as avg_rating,
RANK() OVER(PARTITION BY Branch ORDER BY AVG(rating) DESC) as ranks
 FROM walmart
GROUP BY Branch,category
) AS yes

WHERE ranks = 1;

-- Identify the busiest day for each branch based on the no of transactions

SELECT * from walmart;
SELECT * FROM (
SELECT 
Branch,
DATE_FORMAT(date,'%W') as day_name,
COUNT(*) as 'Transactions',
RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) as ranks
FROM walmart 
GROUP BY Branch,day_name) as yes
WHERE ranks = 1;


-- Determine the average,min,max rating of category for each city
-- List the city , average_rating, minimum_rating and maximum_rating 
SELECT * from walmart;

SELECT City,category,MIN(rating),MAX(rating),AVG(rating) from walmart
GROUP BY City,category
ORDER BY City,category ASC;

-- Calculating total profit for each category by considering total profit as
-- (unit_price * quantity * profit_margin)
-- List the category, total_profit ordered from highest to lowest profit 

SELECT * from walmart;

SELECT category, SUM(unit_price*quantity*profit_margin) as total_profit from walmart
GROUP BY category;

-- Determine the most common payment method for each branch
-- display the branch and preferred mode of payment 
SELECT * FROM(
SELECT Branch,
payment_method,
COUNT(*) as Transactions,
RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) as ranks FROM walmart
GROUP BY Branch,payment_method) as yes
WHERE ranks = 1 ;

-- Categorize sales into 3 groups MORNING, AFTERNOON and EVENING 
-- Find no of invoices for each shift

SELECT 
    CASE
        WHEN HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) BETWEEN 12 and 17 THEN 'Afternoon'
        ELSE 'Evening'
	END AS day_time,
    COUNT(*) AS 'No of invoices'
FROM walmart
GROUP BY day_time
ORDER BY 'No of invoices' DESC;

-- Identify 5 branches with the highest decrease ratio in revenue
-- compared to last year(current year 2023 and last year 2022)

SELECT * from walmart;

WITH rev_2022 AS
(
SELECT 
     Branch,
     SUM(total) as revenue
FROM walmart
WHERE DATE_FORMAT(date,'%Y') = 2022
GROUP BY Branch)
,
rev_2023 AS
(
SELECT 
     Branch,
     SUM(total) as revenue
FROM walmart
WHERE DATE_FORMAT(date,'%Y') = 2023
GROUP BY Branch
)

SELECT 
ls.Branch,
ls.revenue AS 'Revenue in 2022',
cs.revenue AS 'Revenue in 2023',
ROUND((ls.revenue-cs.revenue)/ls.revenue,2) AS dec_res
FROM rev_2022 as ls 
JOIN rev_2023 as cs
ON ls.Branch = cs.Branch
WHERE ls.revenue > cs.revenue
ORDER BY dec_res DESC;















