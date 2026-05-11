use [AdventureWorksDW2022]
go
--Từ bảng DimSalesTerritory, trả về tất cả các cột NGOẠI TRỪ cột
--SalesTerritoryAlternateKey, SalesTerritoryImage
select
SalesTerritoryKey,
SalesTerritoryRegion,
SalesTerritoryCountry,
SalesTerritoryGroup
from DimSalesTerritory

-- câu 2 Từ bảng DimPromotion, trả về đúng 2 cột PromotionKey và English-PromotionName
Select 
PromotionKey, 
EnglishPromotionName
From DimPromotion;

--câu 3 Trả về tất cả các cột trong bảng FactSalesQuota, sắp xếp theo thứ tự từ lớn đến bé với SalesAmountQuota
 select* from FactSalesQuota
 ORDER BY SalesAmountQuota DESC;

 -- CÂU 4 Trong bảng FactSalesQuota, trả về tất cả các bản ghi có date trong năm 2013 và SalesAmountQuota > 1tr.
 --Sắp xếp theo thứ tự từ lớn đến bé với SalesAmountQuota,
 --  và từ bé đến lớn vs employeekey
 select * from FactSalesQuota
where datekey between 20130101 and 20131231
and SalesAmountQuota > 1000000
order by SalesAmountQuota desc,
  employeekey asc ;

  -- câu 5
  -- trong bảng dimproduct 
  --trả về cột ProductKey, Color và StartDate.
  --Các bản ghi thỏa mãn một trong các điều kiện sau:
-- StartDate trong năm 2012 và Class là M
--StartDate trong năm 2013 và có màu đen
select 
ProductKey, 
Color,
StartDate
from DimProduct
where (YEAR(StartDate) = 2012 AND Class = 'M')
or ( year(startdate)=2013 and color='black')

--câu 6
-- Trong bảng DimReseller,
--trả về cột ResellerKey, AnnualRevenue, YearOpened. Các bảnghi thỏa mãn một trong các điều kiện sau:
--Annual Revenue nằm trong khoảng 20000 – 90000
--và YearOpened trong khoảng 1972 – 1978
-- Annual Revenue trong khoảng 100000 – 500000
--và YearOpened trong khoảng 1989 – 2000
--Sắp xếp các bản ghi với AnnualRevenue, YearOpened theo chiều giảm dần
 select
 ResellerKey, 
 AnnualRevenue, 
 YearOpened
 from DimReseller
 where ( AnnualRevenue between 20000 and 90000 
 and YearOpened between 1972 and 1978)
 OR ( AnnualRevenue between 100000 and 500000
 and YearOpened between 1989 and 2000)
 ORDER BY AnnualRevenuE DESC, 
 YearOpened DESC;

 -- CÂU 7 
 --Trong bảng DimReseller, 
 --trả về các bản ghi có bank name thuộc một trong các giá trị sau
--International Security, Primary International, United Security, Primary Bank & Reserve,
--có AnnualSales lớn hơn 1tr và có MinPaymentAmount
SELECT * FROM DimReseller
WHERE BankName IN ('International Security',' Primary International',' United Security', 'Primary Bank & Reserve')
AND AnnualSales > 1000000
  AND MinPaymentAmount IS NOT NULL;

  --câu 8 
--  Trả về TOP 3 công ty có AnnualSales lớn nhất được thành lập trong thế kỉ 21. 
--Biết các công ty này phải thuộc ProductLine là Road
select top 3 
ResellerName, 
 AnnualSales,
 YearOpened,
ProductLine
from DimReseller
WHERE YearOpened >= 2001
  AND ProductLine = 'Road'
ORDER BY AnnualSales DESC;

-- câu 9
-- Trả về FullName, BaseRate (dữ liệu trong bảng DimEmployee) của TOP 5 nhân viên có
--SalesQuotaAmount cao nhất trong năm 2012
select top 5 
CONCAT_WS(' ', e.FirstName, e.MiddleName, e.LastName) AS FullName,
e.BaseRate,
SUM(sq.SalesAmountQuota) AS TotalSalesQuota
from DimEmployee e
INNER JOIN FactSalesQuota sq ON e.EmployeeKey = sq.EmployeeKey
WHERE sq.DateKey BETWEEN 20120101 AND 20121231
GROUP BY 
    e.EmployeeKey, 
    e.FirstName, 
    e.MiddleName, 
    e.LastName, 
    e.BaseRate
ORDER BY TotalSalesQuota DESC;

-- câu 10 
-- Trong bảng DimProduct, trả về ProductName và Productkey 
--của tất cả các sản phẩm có EnglishProductSubcategoryName (bảng DimProductSubcategory) bắt đầu bằng chữ S
select
p.ProductKey,
 p.EnglishProductName AS ProductName
from DimProduct p
inner join DimProductSubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
where ps.EnglishProductSubcategoryName Like 's%'

--câu 11
--Trong bảng DimCustomer, trả về tất cả các cột kèm theo một cột phân loại với logic như sau
--Nếu EnglishCountryRegionName (trong bảng DimGeography) là France,
--Germany, United Kingdom, Australia thì trả về Europe
--Nếu EnglishCountryRegionName là United States, Canada thì trả về America
--Sắp xếp các bản ghi theo Yearly Income từ bé đến lớn
SELECT * FROM (
    SELECT 
        c.*, 
        'Europe' AS Continent
    FROM DimCustomer c
    INNER JOIN DimGeography g ON c.GeographyKey = g.GeographyKey
    WHERE g.EnglishCountryRegionName IN ('France', 'Germany', 'United Kingdom', 'Australia')
    UNION ALL
    SELECT 
        c.*, 
        'America' AS Continent
    FROM DimCustomer c
    INNER JOIN DimGeography g ON c.GeographyKey = g.GeographyKey
    WHERE g.EnglishCountryRegionName IN ('United States', 'Canada')
) AS TempTable
ORDER BY YearlyIncome ASC;

--Câu 12:
--Tính tổng YearlyIncome (trong bảng DimCustomer), theo từng
--English-CountryRegionName (trong bảng DimGeography). Chỉ tính trên các khách hàng
--có EnglishEducation là Bachelors
 SELECT 
    g.EnglishCountryRegionName,
    SUM(c.YearlyIncome) AS TotalYearlyIncome
FROM DimCustomer c
INNER JOIN DimGeography g ON c.GeographyKey = g.GeographyKey
WHERE c.EnglishEducation = 'Bachelors'
GROUP BY g.EnglishCountryRegionName

-- câu 13 
--Trả về ngày mua (OrderDate trong bảng FactInternetSales) gần nhất cho từng
--EnglishProductCategoryName (bảng DimProductCategory)
SELECT 
    pc.EnglishProductCategoryName,
    MAX(fis.OrderDate) AS LatestOrderDate
FROM FactInternetSales fis
INNER JOIN DimProduct p 
    ON fis.ProductKey = p.ProductKey
INNER JOIN DimProductSubcategory ps 
    ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
INNER JOIN DimProductCategory pc 
    ON ps.ProductCategoryKey = pc.ProductCategoryKey
GROUP BY pc.EnglishProductCategoryName;

-- câu 14 Trả về tổng doanh số trong năm 2011 của các khách hàng nam theo từng
--EnglishProductCategoryName (bảng DimProductCategory) và SalesTerritory-Country
--(trong bảng DimSalesTerritory). Chỉ trả về những bản ghi có tổng doanh số > 1000

---CÂU 15 
---a. Trả về các bản ghi trong bảng FactFinance có các cột sau:
-- FinanceKey
--Amount
-- OrganizationName trong bảng DimOrganization
-- DepartmentGroupName trong bảng DimDepartmentGroup
--ScenarioName trong bảng DimScenario
--AccountDescription, AccountType trong bảng DimAccount
SELECT 
    f.FinanceKey,
    f.Amount,
    o.OrganizationName,
    d.DepartmentGroupName,
    s.ScenarioName,
    a.AccountDescription,
    a.AccountType
FROM FactFinance f
INNER JOIN DimOrganization o 
    ON f.OrganizationKey = o.OrganizationKey
INNER JOIN DimDepartmentGroup d 
    ON f.DepartmentGroupKey = d.DepartmentGroupKey
INNER JOIN DimScenario s 
    ON f.ScenarioKey = s.ScenarioKey
INNER JOIN DimAccount a 
    ON f.AccountKey = a.AccountKey

    --b. Trả về một bảng với mẫu như dưới đây
--Phân loại 
--Reseller
--Online
--Trung bình chi tiêu 
--Trung bình số lượng đơn
SELECT 
    'Reseller' AS [Phân loại],
    AVG(SalesAmount) AS [Trung bình chi tiêu],
    AVG(OrderQuantity) AS [Trung bình số lượng đơn]
FROM FactResellerSales
UNION ALL
SELECT 
    'Online' AS [Phân loại],
    AVG(SalesAmount) AS [Trung bình chi tiêu],
    AVG(OrderQuantity) AS [Trung bình số lượng đơn]
FROM FactInternetSales;
