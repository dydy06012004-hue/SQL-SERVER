--Truy vấn trả về bảng kết quả danh sách nhân viên có giới tính Nam và thuộc phòng ban Engineering được hưởng base rate từ 30 đến 40
use [AdventureWorksDW2022]
go
SELECT*
FROM[DimEmployee]
Where Gender='M'
AND DepartmentName='ENGINEERING'
AND Baserate Between 30 AND 40

--Truy vấn trả về danh sách khách hàng là doanh nghiệp
--Được thành lập vào thế kỉ 21, và có doanh số hàng năm lớn hơn hoặc bằng 3000000
--Được thành lập trước thế kỉ 21, và có doanh số bé hơn hoặc bằng 800000
SELECT*
FROM[DimReseller]
WHERE (YearOpened>2000
AND AnnualRevenue >=3000000)
OR (YearOpened<=2000
AND annualrevenue <=800000);

--(Nâng cao) Truy vấn ra danh sách tất cả các sản phẩm có tên bắt đầu bằng chữ HL
SELECT*
FROM[dbo].[DimProduct]
WHERE ENGLISHPRODUCTNAME LIKE 'HL%'
OR SPANISHPRODUCTNAME LIKE 'HL%'
OR FRENCHPRODUCTNAME LIKE 'HL%' 
