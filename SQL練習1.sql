--1
select * from Northwind.dbo.Products where CategoryID = (select top 1 CategoryID from Northwind.dbo.Products order by UnitPrice desc);

--2
select top 1 * from Northwind.dbo.Products where CategoryID = (select top 1 CategoryID from Northwind.dbo.Products order by UnitPrice desc) order by UnitPrice;

--3
select top 1 (select top 1 UnitPrice from Northwind.dbo.Products where CategoryID = (select top 1 CategoryID from Northwind.dbo.Products order by UnitPrice desc) order by UnitPrice desc)-(select top 1 UnitPrice from Northwind.dbo.Products where CategoryID = (select top 1 CategoryID from Northwind.dbo.Products order by UnitPrice desc) order by UnitPrice) as 價差 from Northwind.dbo.Products;

--4
select * from Northwind.dbo.Customers where city in (select City from Northwind.dbo.Customers where CustomerID not in (select CustomerID from Northwind.dbo.Orders));

--5
select CategoryID as 第5貴 from Northwind.dbo.Products order by UnitPrice desc offset 4 rows fetch next 1 rows only;
select CategoryID as 第8便宜 from Northwind.dbo.Products order by UnitPrice offset 7 rows fetch next 1 rows only;

--6
select ContactName from Northwind.dbo.Customers where CustomerID in (select CustomerID from Northwind.dbo.Orders where OrderID in (select OrderID from Northwind.dbo.[Order Details] where ProductID = (select ProductID from Northwind.dbo.Products order by UnitPrice desc offset 4 rows fetch next 1 rows only)));
select ContactName from Northwind.dbo.Customers where CustomerID in (select CustomerID from Northwind.dbo.Orders where OrderID in (select OrderID from Northwind.dbo.[Order Details] where ProductID = (select ProductID from Northwind.dbo.Products order by UnitPrice offset 7 rows fetch next 1 rows only)));

--7
select LastName, FirstName from Northwind.dbo.Employees where EmployeeID in (select EmployeeID from Northwind.dbo.Orders where OrderID in (select OrderID from Northwind.dbo.[Order Details] where ProductID = (select ProductID from Northwind.dbo.Products order by UnitPrice desc offset 4 rows fetch next 1 rows only)));
select LastName, FirstName from Northwind.dbo.Employees where EmployeeID in (select EmployeeID from Northwind.dbo.Orders where OrderID in (select OrderID from Northwind.dbo.[Order Details] where ProductID = (select ProductID from Northwind.dbo.Products order by UnitPrice offset 7 rows fetch next 1 rows only)));

--8
select * from Northwind.dbo.Orders where day(OrderDate) = 13 and datepart(weekday,OrderDate) = 6;

--9
select ContactName from Northwind.dbo.Customers where CustomerID in (select CustomerID from Northwind.dbo.Orders where day(OrderDate) = 13 and datepart(weekday,OrderDate) = 6);

--10
select OrderID, o.ProductID, ProductName from Northwind.dbo.[Order Details] o inner join Northwind.dbo.Products p on o.ProductID = p.ProductID where OrderID in (select OrderID from Northwind.dbo.Orders where day(OrderDate) = 13 and datepart(weekday,OrderDate) = 6);

--11
select * from Northwind.dbo.[Order Details] where Discount = 0;

--12
select c.ContactName, s.Country as suppliers_country, c.Country as customers_country from Northwind.dbo.Orders o1 left join Northwind.dbo.[Order Details] o2 on o1.OrderID = o2.OrderID left join Northwind.dbo.Customers c on o1.CustomerID = c.CustomerID left join Northwind.dbo.Products p on o2.ProductID = p.ProductID left join Northwind.dbo.Suppliers s on p.SupplierID = s.SupplierID where s.Country <> c.Country;

--13
select c.ContactName, c.City from Northwind.dbo.Customers c inner join Northwind.dbo.Employees e on c.City = e.City;

--14
select * from Northwind.dbo.Products where ProductID not in (select distinct ProductID from Northwind.dbo.[Order Details]);
