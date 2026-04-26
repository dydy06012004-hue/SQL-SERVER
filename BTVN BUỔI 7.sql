-- bài 7 
use [AdventureWorksDW2022]
go
-- Bài tập 2 
--Viết truy vấn xếp hạng giá trị EndOfDayRate theo từng CurrencyKey trong bảng FactCurrencyRate. 
select
CurrencyKey,
EndOfDayRate,
DENSE_RANK() OVER (PARTITION BY CurrencyKey ORDER BY EndOfDayRate DESC) AS Rank_DenseRank
from FactCurrencyRate

--Bài tập 3
--Viết truy vấn xếp hạng ServiceGrade theo từng WageType 
--và Shift trong bảng FactCallCenter. 
select 
WageType, 
Shift, 
ServiceGrade,
DENSE_RANK() OVER (
PARTITION BY WageType, Shift 
ORDER BY ServiceGrade DESC
) AS Ranked_ServiceGrade
from FactCallCenter

--Bài tập 4
--Viết truy vấn xếp hạng ListPrice trong bảng DimProduct theo từng
--EnglishProductSubcategoryName trong bảng DimProductSubcategory 
select
ps.EnglishProductSubcategoryName,
p.EnglishProductName,
p.ListPrice,
DENSE_RANK() OVER ( PARTITION BY ps.EnglishProductSubcategoryName ORDER BY p.ListPrice DESC ) as PriceRank
from DimProduct p
JOIN DimProductSubcategory ps 
ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey

--Bài tập 5
--Viết truy vấn trả về TOP 3 EmployeeKey 
--có chỉ tiêu cao nhất theo từng năm trong bảng FactSalesQuota. 
WITH RankedSales AS (
select
CalendarYear,
EmployeeKey,
SalesAmountQuota,
DENSE_RANK() OVER ( PARTITION BY CalendarYear ORDER BY SalesAmountQuota DESC ) AS QuotaRank  
from FactSalesQuota
)
SELECT 
    CalendarYear,
    EmployeeKey,
    SalesAmountQuota
FROM RankedSales
WHERE QuotaRank <= 3
ORDER BY CalendarYear DESC, QuotaRank ASC

--Truy vấn lồng với CTE 
--Bài tập 1
--Viết truy vấn trả về bảng kết quả trả lời các câu hỏi sau: 
--Trung bình một Reseller chi tiêu bao nhiêu tiền?
--Trung bình một Reseller mua bao nhiêu đơn hàng? 
--  Trung bình một khách hàng online chi tiêu bao nhiêu tiền? 
-- Trung bình một khách hàng online mua bao nhiêu đơn? 
SELECT
'Reseller' AS [Phân loại],
    SUM(SalesAmount) / COUNT(DISTINCT ResellerKey) AS [Trung bình chi tiêu],
    COUNT(SalesOrderNumber) * 1.0 / COUNT(DISTINCT ResellerKey) AS [Trung bình số lượng đơn]
FROM FactResellerSales
UNION ALL
SELECT 
    'Online' AS [Phân loại],
    SUM(SalesAmount) / COUNT(DISTINCT CustomerKey) AS [Trung bình chi tiêu],
    COUNT(SalesOrderNumber) * 1.0 / COUNT(DISTINCT CustomerKey) AS [Trung bình số lượng đơn]
FROM FactInternetSales

--Bài tập 2
--Viết truy vấn trả về bảng kết quả 
--YEAR, Total SalesAmount (Internet),Total SalesAmount (Reseller)
    -- Tính tổng doanh thu theo năm từ bảng Reseller

 	 	 
 	 	 


















