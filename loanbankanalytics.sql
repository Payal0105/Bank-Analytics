CREATE DATABASE LoanBankData;
use LoanBankData;

CREATE TABLE BankDataAnalytics (
  Account_ID VARCHAR(30),
  Age VARCHAR(20),
  BH_Name VARCHAR(100),
  Bank_Name VARCHAR(100),
  Branch_Name VARCHAR(100),
  Caste VARCHAR(20),
  Center_Id VARCHAR(30),
  City VARCHAR(50),
  Client_id VARCHAR(20),
  Client_Name VARCHAR(100),
  Close_Client VARCHAR(10),
  Closed_Date VARCHAR(30),
  Credif_Officer_Name VARCHAR(100),
  Dateof_Birth VARCHAR(30),
  Disb_By VARCHAR(100),
  Disbursement_Date VARCHAR(30),
  Disbursement_Date_Years VARCHAR(20),
  Gender_ID VARCHAR(10),
  Home_Ownership VARCHAR(20),
  Loan_Status VARCHAR(50),
  Loan_Transferdate VARCHAR(30),
  NextMeetingDate VARCHAR(30),
  Product_Code VARCHAR(20),
  Grrade VARCHAR(10),
  Sub_Grade VARCHAR(10),
  Product_Id VARCHAR(20),
  Purpose_Category VARCHAR(50),
  Region_Name VARCHAR(50),
  Religion VARCHAR(50),
  Verification_Status VARCHAR(50),
  State_Abbr VARCHAR(10),
  State_Name VARCHAR(50),
  Tranfer_Logic VARCHAR(10),
  Is_Delinquent_Loan VARCHAR(5),
  Is_Default_Loan VARCHAR(5),
  Age_T VARCHAR(10),
  Delinq_2_Yrs VARCHAR(10),
  Application_Type VARCHAR(20),
  Loan_Amount VARCHAR(20),
  Funded_Amount VARCHAR(20),
  Funded_Amount_Inv VARCHAR(20),
  Term VARCHAR(30),
  Int_Rate VARCHAR(10),
  Total_Pymnt VARCHAR(20),
  Total_Pymnt_inv VARCHAR(20),
  Total_Rec_Prncp VARCHAR(20),
  Total_Fees VARCHAR(20),
  Total_Rrec_int VARCHAR(20),
  Total_Rec_Late_fee VARCHAR(20),
  Recoveries VARCHAR(20),
  Collection_Recovery_fee VARCHAR(20)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bank Data Analystics.csv'
INTO TABLE `BankDataAnalytics`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE BankDataAnalytics
MODIFY Tranfer_Logic VARCHAR(100);

-- q1 
SELECT SUM(CAST(Funded_Amount AS DECIMAL(15,2))) AS Total_Loan_Amount_Funded
FROM BankDataAnalytics;

-- q2 
SELECT COUNT(*) AS Total_Loans
FROM BankDataAnalytics;

-- q3
SELECT 
    SUM(CAST(Total_Rec_Prncp AS DECIMAL(15,2))) 
    + SUM(CAST(Total_Rrec_Int AS DECIMAL(15,2))) AS Total_Collection
FROM BankDataAnalytics;

-- q4
SELECT SUM(CAST(Total_Rrec_Int AS DECIMAL(15,2))) AS Total_Interest
FROM BankDataAnalytics;

-- q5 
SELECT Branch_Name,
       SUM(CAST(Total_Rrec_Int AS DECIMAL(15,2))) AS Total_Interest,
       SUM(CAST(Total_Fees AS DECIMAL(15,2))) AS Total_Fees,
       SUM(CAST(Total_Rrec_Int AS DECIMAL(15,2)) + CAST(Total_Fees AS DECIMAL(15,2))) AS Total_Revenue
FROM BankDataAnalytics
GROUP BY Branch_Name
ORDER BY Total_Revenue DESC;

-- q6
SELECT State_Name, COUNT(*) AS Loan_Count
FROM BankDataAnalytics
GROUP BY State_Name
ORDER BY Loan_Count DESC;

-- q7
SELECT Religion, COUNT(*) AS Loan_Count
FROM BankDataAnalytics
GROUP BY Religion
ORDER BY Loan_Count DESC;

-- q8
SELECT Product_Id, COUNT(*) AS Loan_Count
FROM BankDataAnalytics
GROUP BY Product_Id
ORDER BY Loan_Count DESC;

-- q9
SELECT YEAR(STR_TO_DATE(Disbursement_Date, '%d-%m-%Y')) AS Year, COUNT(*) AS Loan_Count
FROM BankDataAnalytics
GROUP BY Year
ORDER BY Year DESC;

-- q10
SELECT Grrade, COUNT(*) AS Loan_Count
FROM BankDataAnalytics
GROUP BY Grrade
ORDER BY Loan_Count DESC;

-- q11
SELECT COUNT(*) AS Default_Loan_Count
FROM BankDataAnalytics
WHERE Is_Default_Loan = 'Y';

-- q12
SELECT COUNT(DISTINCT Client_id) AS Delinquent_Clients
FROM BankDataAnalytics
WHERE Is_Delinquent_Loan = 'Y';

-- q13
SELECT 
    ROUND(SUM(CASE WHEN Is_Delinquent_Loan = 'Y' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Delinquent_Loan_Rate
FROM BankDataAnalytics;

-- q14
SELECT 
    ROUND(SUM(CASE WHEN Is_Default_Loan = 'Y' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Default_Loan_Rate
FROM BankDataAnalytics;

-- q15
SELECT Loan_Status, COUNT(*) AS Loan_Count
FROM BankDataAnalytics
GROUP BY Loan_Status
ORDER BY Loan_Count DESC;

-- q16
SELECT Age, COUNT(*) AS Loan_Count
FROM BankDataAnalytics
GROUP BY Age
ORDER BY Loan_Count DESC;

-- q17
SELECT COUNT(*) AS No_Verified_Loan
FROM BankDataAnalytics
WHERE Verification_Status NOT LIKE '%Verified%';

-- q18
SELECT Term, COUNT(*) AS Loan_Count
FROM BankDataAnalytics
GROUP BY Term
ORDER BY Loan_Count DESC;

