use [AdventureWorksDW2022]
go
--Chuẩn hóa cột YearlyIncome (DimCustomer) theo phương pháp Min-Max về [0,1].
--Liệt kê Top 10 khách hàng có thu nhập cao nhất sau khi chuẩn hóa. 
with incomestats AS (
--TÍNH giá trị min và max để chuẩn hoá
select
MIN(YearlyIncome) AS MinIncome,
Max(YearlyIncome) as maxincome
from DimCustomer
where YearlyIncome IS NOT NULL
)
SELECT TOP 10
c.FirstName, 
c.LastName, 
c.YearlyIncome,
CAST((c.YearlyIncome - s.MinIncome) AS FLOAT) / 
NULLIF((s.MaxIncome - s.MinIncome), 0) AS NormalizedIncome
FROM DimCustomer C
CROSS JOIN IncomeStats s
ORDER BY NormalizedIncome DESC;
GO

-- Bài tập 1 
--Viết truy vấn trả về bảng kết quả chứa số đơn hàng của Reseller, mã Reseller, tên chương trình khuyến mãi mà Reseller được hưởng
--Lưu ý: dữ liệu tại bảng kết quả không được trùng nhau (tham khảo SELECT DISTINCT) 
SELECT DISTINCT
    FRS.ResellerKey,
    FRS.SalesOrderNumber,
    DP.EnglishPromotionName
FROM FactResellerSales AS FRS
INNER JOIN DimPromotion AS DP 
    ON FRS.PromotionKey = DP.PromotionKey

 --Bài tập 2
 --Viết truy vấn trả về bảng kết quả bao gồm số đơn hàng, SalesOrderLineNumber, mã sản phẩm, số lượng mua, màu sắc, size, đơn giá, tên khách hàng, địa chỉ, giới tính 
 select 
 FIS.SalesOrderNumber,
 FIS.SalesOrderLineNumber,
 FIS.ProductKey,
 FIS.OrderQuantity,
 DP.Color,
 DP.Size,
 FIS.UnitPrice,
 DC.FirstName + ' ' + DC.LastName AS CustomerName,
 DC.AddressLine1,
 DC.Gender
 from FactInternetSales AS FIS
 INNER JOIN DimProduct AS DP
 ON FIS.ProductKey = DP.ProductKey
INNER JOIN DimCustomer AS DC 
 ON FIS.CustomerKey = DC.CustomerKey

--Bài tập 3: 
--Viết truy vấn trả về bảng kết quả theo mẫu dưới đây. Biết rằng bảng kết quả bao gồm số lượng đơn hàng online tương ứng với từng màu sắc của sản phẩm.
SELECT
DP.COLOR AS [ MÀU SẮC SẢN PHẨM ],
COUNT (FIS.SalesOrderNumber) AS [Số lượng đơn hàng online]
FROM FactInternetSales AS FIS
INNER JOIN DimProduct AS DP
ON FIS.ProductKey = DP.ProductKey
GROUP BY DP.Color

--Bài tập 4
--Viết truy vấn tính trung bình số lượng mua theo từng Size sản phẩm của các khách hàng sinh sau 1980. 
SELECT
DP.Size,
AVG(FIS.OrderQuantity) AS [Trung bình số lượng mua]
FROM FactInternetSales AS FIS
INNER JOIN DimProduct AS DP
ON FIS.ProductKey = DP.ProductKey
JOIN DimCustomer AS DC 
ON FIS.CustomerKey = DC.CustomerKey
WHERE YEAR(DC.BIRTHDATE)>1980
GROUP BY DP.Size

--Bài tập 5
--Hãy viết truy vấn để trả về bảng kết quả thể hiện doanh số từ năm 2012 – 2014 theo từng năm
--và theo từng quốc gia, đồng thời, tạo thêm một cột Bonus vùng tương đương 10% doanh số 
SELECT 
    DST.SalesTerritoryCountry AS [Quốc gia],
    DD.CalendarYear AS [Năm],
    SUM(FIS.SalesAmount) AS [Doanh số],
    SUM(FIS.SalesAmount) * 0.1 AS [Bonus vùng]
FROM FactInternetSales AS FIS
INNER JOIN DimDate AS DD 
    ON FIS.OrderDateKey = DD.DateKey
INNER JOIN DimSalesTerritory AS DST 
    ON FIS.SalesTerritoryKey = DST.SalesTerritoryKey
WHERE DD.CalendarYear BETWEEN 2012 AND 2014
GROUP BY DST.SalesTerritoryCountry, DD.CalendarYear

--Bài tập 6
--Viết truy vấn trả về mã đơn hàng online trong năm 2011 được mua bởi khách hàng nữ sinh sau 1980
-- số orderline, mã khách hàng, mã sản phẩm, số lượng mua, và cột phân loại theo logic sau: 
--Màu Black, Blue, Grey, Red được phân loại là DarkColor 
--Màu Black, Blue, Grey, Red được phân loại là DarkColor 
SELECT
FIS.SALESORDERNUMBER,
FIS.SALESORDERLINENUMBER,
FIS.CustomerKey,
FIS.ProductKey,
FIS.OrderQuantity,
CASE
WHEN DP.Color IN ('Black', 'Blue', 'Grey', 'Red') THEN 'DarkColor'
WHEN DP.Color IN ('Silver', 'Silver/Black', 'White', 'Yellow') THEN 'BrightColor'
ELSE DP.Color
END AS ColorCategory
FROM FactInternetSales AS FIS
INNER JOIN DimProduct AS DP 
    ON FIS.ProductKey = DP.ProductKey
INNER JOIN DimCustomer AS DC 
    ON FIS.CustomerKey = DC.CustomerKey
WHERE YEAR(FIS.OrderDate) = 2011
  AND DC.Gender = 'F'
  AND YEAR(DC.BirthDate) > 1980

  --Bài tập 7
  --Viết truy vấn tính tổng số lượng mua các đơn hàng online theo từng phân loại màu sắc: 
  --Màu Black, Blue, Grey, Red được phân loại là DarkColor 
  --Silver, Silver/Black, White, Yellow được phân loại là BrightColor - Các màu khác giữ nguyên 
  --Biết rằng các đơn hàng này được mua năm 2011 được mua bởi khách hàng nữ sinh sau 1980.
  SELECT 
    CASE 
        WHEN DP.Color IN ('Black', 'Blue', 'Grey', 'Red') THEN 'DarkColor'
        WHEN DP.Color IN ('Silver', 'Silver/Black', 'White', 'Yellow') THEN 'BrightColor'
        ELSE DP.Color
    END AS ColorCategory,
    SUM(FIS.OrderQuantity) AS TotalOrderQuantity
FROM FactInternetSales AS FIS
INNER JOIN DimProduct AS DP 
    ON FIS.ProductKey = DP.ProductKey
INNER JOIN DimCustomer AS DC 
    ON FIS.CustomerKey = DC.CustomerKey
WHERE YEAR(FIS.OrderDate) = 2011
  AND DC.Gender = 'F'
  AND YEAR(DC.BirthDate) > 1980
GROUP BY 
    CASE 
        WHEN DP.Color IN ('Black', 'Blue', 'Grey', 'Red') THEN 'DarkColor'
        WHEN DP.Color IN ('Silver', 'Silver/Black', 'White', 'Yellow') THEN 'BrightColor'
        ELSE DP.Color
    END