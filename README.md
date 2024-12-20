# Walmart Data Analysis

## Project Overview

I developed this end-to-end data analysis project to extract critical business insights from Walmart sales data. Using Python for data processing and analysis, SQL for advanced querying, and structured problem-solving techniques, I tackled key business questions. This project has been an excellent opportunity for me to refine my skills in data manipulation, SQL querying, and data pipeline creation

---

## Project Workflow

### 1. Set Up the Environment
   - **Tools Used**: Visual Studio Code (VS Code), Python, SQL (MySQL)
   - **Goal**: Create a structured workspace within VS Code and organize project folders for smooth development and data handling.

### 2. Set Up Kaggle API
   - **API Setup**: Obtained Kaggle API token from [Kaggle](https://www.kaggle.com/) and downloaded the JSON file.
   - **Configure Kaggle**: 
      - Placed the downloaded `kaggle.json` file in the local `.kaggle` folder.
      - Used the command `kaggle datasets download -d <dataset-path>` to pull datasets directly into the project.

### 3. Download Walmart Sales Data
   - **Data Source**: Used the Kaggle API to download the Walmart sales datasets from Kaggle.
   - **Dataset Link**: [Walmart Sales Dataset](https://www.kaggle.com/najir0123/walmart-10k-sales-datasets)
   - **Storage**: Saved the data in the `data/` folder for easy reference and access.

### 4. Install Required Libraries and Load Data
   - **Libraries**: Installed necessary Python libraries using:
     ```bash
     pip install pandas numpy sqlalchemy mysql-connector-python psycopg2
     ```
   - **Loading Data**: Read the data into a Pandas DataFrame for initial analysis and transformations.

### 5. Explore the Data
   - **Goal**: Conduct an initial data exploration to understand data distribution, check column names, types, and identify potential issues.
   - **Analysis**: Use functions like `.info()`, `.describe()`, and `.head()` to get a quick overview of the data structure and statistics.

### 6. Data Cleaning
   - **Removed Duplicates**: Identified and removed duplicate entries to avoid skewed results.
   - **Handled Missing Values**: Dropped rows or columns with missing values if they were insignificant; filled values where essential.
   - **Fixed Data Types**: Ensured all columns have consistent data types (e.g., dates as `datetime`, prices as `float`).
   - **Currency Formatting**: Used `.replace()` to handle and format currency values for analysis.
   - **Validation**: Checked for any remaining inconsistencies and verified the cleaned data.

### 7. Feature Engineering
   - **Create New Columns**: Calculated the `Total Amount` for each transaction by multiplying `unit_price` by `quantity` and adding this as a new column.
   - **Enhance Dataset**: Adding this calculated field will streamline further SQL analysis and aggregation tasks.

### 8. Load Data into MySQL 
   - **Set Up Connections**: Connected to MySQL using `sqlalchemy` and loaded the cleaned data into each database.
   - **Table Creation**: Set up tables in MySQL using Python SQLAlchemy to automate table creation and data insertion.

### 9. SQL Analysis: Complex Queries and Business Problem Solving
   - **Business Problem-Solving**: Wrote and executed complex SQL queries to answer critical business questions, such as:
     - Revenue trends across branches and categories.
     - Identified best-selling product categories.
     - Sales performance by time, city, and payment method.
     - Analyzed peak sales periods and customer buying patterns.
     - Profit margin analysis by branch and category.

---

## Requirements

- **Python 3.8+**
- **SQL Databases**: MySQL, PostgreSQL
- **Python Libraries**:
  - `pandas`, `numpy`, `sqlalchemy`, `mysql-connector-python`, 
- **Kaggle API Key** (for data downloading)

## Getting Started

1. Cloned the repository:
   ```bash
   git clone <repo-url>
   ```
2. Installed Python libraries:
   ```bash
   pip install -r requirements.txt
   ```
3. Set up Kaggle API, downloaded the data, loaded data for analysis.

4. ### Business Problems and SQL Queries

Below are the business problems I addressed as part of the Walmart data analysis project, along with the corresponding SQL queries. These queries reflect my approach to solving real-world analytical challenges using structured problem-solving techniques.

---

#### 1. **Finding the Number of Transactions and Quantities Sold for Each Payment Method**  
I analyzed the sales data to identify the total number of transactions and quantities sold for each payment method.  

**SQL Query:**  
```sql
SELECT payment_method, COUNT(*) AS 'Transactions', SUM(quantity) AS 'Total Quantity' 
FROM walmart 
GROUP BY payment_method;
```

---

#### 2. **Identifying the Highest-Rated Category in Each Branch**  
I determined the category with the highest average rating for each branch to understand customer preferences.  

**SQL Query:**  
```sql
SELECT Branch, category, AVG(rating) AS avg_rating 
FROM (
    SELECT Branch, category, AVG(rating) AS avg_rating, 
           RANK() OVER(PARTITION BY Branch ORDER BY AVG(rating) DESC) AS ranks 
    FROM walmart 
    GROUP BY Branch, category
) AS ranked_data 
WHERE ranks = 1;
```

---

#### 3. **Identifying the Busiest Day for Each Branch**  
I examined transaction data to determine the busiest day of the week for each branch.  

**SQL Query:**  
```sql
SELECT Branch, DATE_FORMAT(date, '%W') AS day_name, COUNT(*) AS 'Transactions' 
FROM (
    SELECT Branch, DATE_FORMAT(date, '%W') AS day_name, COUNT(*) AS 'Transactions', 
           RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) AS ranks 
    FROM walmart 
    GROUP BY Branch, day_name
) AS ranked_data 
WHERE ranks = 1;
```

---

#### 4. **Determining the Average, Minimum, and Maximum Ratings of Categories by City**  
I analyzed product ratings to calculate the average, minimum, and maximum ratings for each category in every city.  

**SQL Query:**  
```sql
SELECT City, category, MIN(rating) AS min_rating, MAX(rating) AS max_rating, AVG(rating) AS avg_rating 
FROM walmart 
GROUP BY City, category 
ORDER BY City, category ASC;
```

---

#### 5. **Calculating Total Profit for Each Category**  
I calculated the total profit for each product category by considering the formula:  
`total_profit = unit_price * quantity * profit_margin`.  

**SQL Query:**  
```sql
SELECT category, SUM(unit_price * quantity * profit_margin) AS total_profit 
FROM walmart 
GROUP BY category 
ORDER BY total_profit DESC;
```

---

#### 6. **Determining the Most Common Payment Method for Each Branch**  
I identified the most preferred payment method for each branch to uncover customer preferences.  

**SQL Query:**  
```sql
SELECT Branch, payment_method, COUNT(*) AS Transactions 
FROM (
    SELECT Branch, payment_method, COUNT(*) AS Transactions, 
           RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) AS ranks 
    FROM walmart 
    GROUP BY Branch, payment_method
) AS ranked_data 
WHERE ranks = 1;
```

---

#### 7. **Categorizing Sales into Time Shifts**  
I segmented transactions into three time shifts: Morning, Afternoon, and Evening, to understand sales distribution across the day.  

**SQL Query:**  
```sql
SELECT 
    CASE
        WHEN HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS day_time, 
    COUNT(*) AS 'No of Invoices' 
FROM walmart 
GROUP BY day_time 
ORDER BY 'No of Invoices' DESC;
```

---

#### 8. **Identifying Branches with the Highest Revenue Decrease**  
I analyzed revenue data from 2022 and 2023 to identify branches with the most significant decrease in revenue.  

**SQL Query:**  
```sql
WITH rev_2022 AS (
    SELECT Branch, SUM(total) AS revenue 
    FROM walmart 
    WHERE DATE_FORMAT(date, '%Y') = 2022 
    GROUP BY Branch
), 
rev_2023 AS (
    SELECT Branch, SUM(total) AS revenue 
    FROM walmart 
    WHERE DATE_FORMAT(date, '%Y') = 2023 
    GROUP BY Branch
) 
SELECT rev_2022.Branch, rev_2022.revenue AS 'Revenue in 2022', 
       rev_2023.revenue AS 'Revenue in 2023', 
       ROUND((rev_2022.revenue - rev_2023.revenue) / rev_2022.revenue, 2) AS dec_ratio 
FROM rev_2022 
JOIN rev_2023 ON rev_2022.Branch = rev_2023.Branch 
WHERE rev_2022.revenue > rev_2023.revenue 
ORDER BY dec_ratio DESC;
```

---



---


---

---

## License

This project is licensed under the MIT License. 

---
- **Data Source**: Kaggle’s Walmart Sales Dataset
- **Inspiration**: Walmart’s business case studies on sales and supply chain optimization.

---
