CREATE DATABASE bank_data;

USE bank_data;

CREATE TABLE debit_analytics (
  CustomerID VARCHAR(50),
  CustomerName VARCHAR(100),
  AccountNumber VARCHAR(20),
  TransactionDate DATE,
  TransactionType VARCHAR(10),
  Amount DECIMAL(12,2),
  Balance DECIMAL(12,2),
  Description TEXT,
  Branch VARCHAR(100),
  TransactionMethod VARCHAR(50),
  Currency VARCHAR(10),
  BankName VARCHAR(100)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Debit and Credit banking_data.csv'
INTO TABLE debit_analytics
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'  -- Use '\n' on Linux/Mac
IGNORE 1 ROWS;

SELECT * FROM debit_analytics LIMIT 10;

-- q1 
SELECT SUM(Amount) AS Total_Credit_Amount
FROM debit_analytics
WHERE TransactionType = 'Credit';

-- q2
SELECT SUM(Amount) AS Total_Debit_Amount
FROM debit_analytics
WHERE TransactionType = 'Debit';

-- q3
SELECT 
  (SELECT SUM(Amount) FROM debit_analytics WHERE TransactionType = 'Credit') / 
  (SELECT SUM(Amount) FROM debit_analytics WHERE TransactionType = 'Debit') 
  AS Credit_Debit_Ratio;

-- q4
SELECT 
  (SELECT SUM(Amount) FROM debit_analytics WHERE TransactionType = 'Credit') -
  (SELECT SUM(Amount) FROM debit_analytics WHERE TransactionType = 'Debit') 
  AS Net_Transaction_Amount;

-- q5
SELECT 
  CustomerID,
  COUNT(*) / MAX(Balance) AS Account_Activity_Ratio
FROM debit_analytics
GROUP BY CustomerID
ORDER BY Account_Activity_Ratio DESC;

-- q6
-- per day 
SELECT TransactionDate, COUNT(*) AS Transaction_Count
FROM debit_analytics
GROUP BY TransactionDate
ORDER BY Transaction_Count DESC;

-- per month
SELECT 
  DATE_FORMAT(TransactionDate, '%Y-%m') AS Month,
  COUNT(*) AS Transaction_Count
FROM debit_analytics
GROUP BY Month
ORDER BY Transaction_Count DESC;

-- q7
SELECT 
  Branch,
  SUM(Amount) AS Total_Amount
FROM debit_analytics
GROUP BY Branch
ORDER BY Total_Amount DESC;

-- q8
SELECT 
  BankName,
  SUM(Amount) AS Total_Amount
FROM debit_analytics
GROUP BY BankName
ORDER BY Total_Amount DESC;

-- q9
SELECT 
  TransactionMethod,
  COUNT(*) AS Transaction_Count,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM debit_analytics), 2) AS Percentage
FROM debit_analytics
GROUP BY TransactionMethod
ORDER BY Transaction_Count DESC;

-- q10 
SELECT 
  Branch,
  DATE_FORMAT(TransactionDate, '%Y-%m') AS Month,
  SUM(Amount) AS Total_Amount
FROM debit_analytics
GROUP BY Branch, Month
ORDER BY Branch, Month;

-- q11
SELECT 
  *,
  CASE 
    WHEN Amount > 4000 THEN 'High-Risk'
    ELSE 'Normal'
  END AS Risk_Flag
FROM debit_analytics
ORDER BY Amount DESC;

-- q12
SELECT 
  CustomerID,
  COUNT(*) AS Suspicious_Count
FROM debit_analytics
WHERE Amount > 4000
GROUP BY CustomerID
ORDER BY Suspicious_Count DESC;


