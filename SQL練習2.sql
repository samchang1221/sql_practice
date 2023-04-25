--1
select * from Northwind.dbo.Orders where OrderDate = eomonth(OrderDate);

--2
select distinct ProductName from Northwind.dbo.[Order Details] o inner join Northwind.dbo.Products p on o.ProductID = p.ProductID where OrderID in (select OrderID from Northwind.dbo.Orders where OrderDate = eomonth(OrderDate));

--3
select ContactName from Northwind.dbo.Customers where CustomerID in (select top 3 CustomerID from Northwind.dbo.[Order Details] o1 inner join Northwind.dbo.Orders o2 on o1.OrderID = o2.OrderID where ProductID in (select top 3 ProductID from Northwind.dbo.Products order by UnitPrice desc) order by UnitPrice*Quantity*(1-Discount) desc);

--4
select ContactName from Northwind.dbo.Customers where CustomerID in (select top 3 CustomerID from Northwind.dbo.[Order Details] o1 inner join Northwind.dbo.Orders o2 on o1.OrderID = o2.OrderID where ProductID in (select top 3 ProductID from Northwind.dbo.Products order by UnitPrice desc) order by UnitPrice*Quantity*(1-Discount) desc);

--5
select ContactName from Northwind.dbo.Customers where CustomerID in (select top 3 o2.CustomerID from Northwind.dbo.[Order Details] o1 inner join Northwind.dbo.Orders o2 on o1.OrderID = o2.OrderID inner join Northwind.dbo.Products p on o1.ProductID = p.ProductID where CategoryID in (select top 3 CategoryID from Northwind.dbo.Products order by UnitPrice desc) order by o1.UnitPrice*Quantity*(1-Discount) desc);

--6
select o1.OrderID, sum(UnitPrice*Quantity*(1-Discount)) as total from Northwind.dbo.[Order Details] o1 group by o1.OrderID having sum(UnitPrice*Quantity*(1-Discount)) > (select avg(UnitPrice*Quantity*(1-Discount)) as total from Northwind.dbo.[Order Details]) order by OrderID;
select OrderID, ContactName from Northwind.dbo.Customers c inner join Northwind.dbo.Orders o on o.CustomerID = c.CustomerID where OrderID in (select o1.OrderID from Northwind.dbo.[Order Details] o1 group by o1.OrderID having sum(UnitPrice*Quantity*(1-Discount)) > (select avg(UnitPrice*Quantity*(1-Discount)) as total from Northwind.dbo.[Order Details])) order by OrderID;

--7
select top 1 ProductID, sum(Quantity) as quantity, sum(UnitPrice*Quantity*(1-Discount)) as total from Northwind.dbo.[Order Details] group by ProductID order by sum(Quantity) desc;

--8
select top 1 o.ProductID, sum(Quantity) as quantity, p.ProductName from Northwind.dbo.[Order Details] o inner join Northwind.dbo.Products p on o.ProductID = p.ProductID group by o.ProductID, p.ProductName order by sum(Quantity);

--9
select top 1 sum(Quantity) as quantity, p.CategoryID from Northwind.dbo.[Order Details] o inner join Northwind.dbo.Products p on o.ProductID = p.ProductID group by p.CategoryID order by sum(Quantity);

--10
select c.ContactName, sum(UnitPrice*Quantity*(1-Discount)) as total from Northwind.dbo.Orders o1 inner join Northwind.dbo.Customers c on o1.CustomerID = c.CustomerID inner join Northwind.dbo.[Order Details] o2 on o1.OrderID = o2.OrderID where o1.EmployeeID = (select top 1 EmployeeID as order_ID from Northwind.dbo.Orders group by EmployeeID order by count(OrderID) desc) group by c.ContactName order by sum(UnitPrice*Quantity*(1-Discount)) desc

--11
select c.ContactName, sum(UnitPrice*Quantity*(1-Discount)) as total from Northwind.dbo.Orders o1 inner join Northwind.dbo.Customers c on o1.CustomerID = c.CustomerID inner join Northwind.dbo.[Order Details] o2 on o1.OrderID = o2.OrderID group by c.ContactName order by sum(UnitPrice*Quantity*(1-Discount)) desc

--12
select * from Northwind.dbo.Products where ProductID not in (select distinct ProductID from Northwind.dbo.[Order Details]);

--13
select CustomerID, sum(UnitPrice*Quantity*(1-Discount)) as total from Northwind.dbo.[Order Details] o1 inner join Northwind.dbo.Orders o2 on o1.OrderID = o2.OrderID where o2.CustomerID in (select CustomerID from Northwind.dbo.Customers where fax is null) group by o2.CustomerID

--14
select c.City, p.CategoryID, sum(o2.Quantity) as Quantity from Northwind.dbo.Orders o1 left join Northwind.dbo.[Order Details] o2 on o1.OrderID = o2.OrderID left join Northwind.dbo.Customers c on o1.CustomerID = c.CustomerID left join Northwind.dbo.Products p on o2.ProductID = p.ProductID group by c.City, p.CategoryID order by c.City;

--15
select o.ProductID, sum(o.Quantity) as Quantity from Northwind.dbo.[Order Details] o left join Northwind.dbo.Products p on o.ProductID = p.ProductID where p.UnitsOnOrder = 0 group by o.ProductID order by o.ProductID;

--16
select c.ContactName, p.ProductName from Northwind.dbo.[Order Details] o1 left join Northwind.dbo.Products p on o1.ProductID = p.ProductID left join Northwind.dbo.Orders o2 on o1.OrderID = o2.OrderID left join Northwind.dbo.Customers c on o2.CustomerID = c.CustomerID where p.UnitsOnOrder = 0 group by c.ContactName, p.ProductName order by p.ProductName;

--17
select EmployeeID, sum(UnitPrice*Quantity*(1-Discount)) as total from Northwind.dbo.[Order Details] o1 left join Northwind.dbo.Orders o2 on o1.OrderID = o2.OrderID group by EmployeeID order by EmployeeID

--18
with added_row_number as (select ShipName, CategoryID, sum(Quantity) as all_quantity, row_number() over(partition by ShipName order by ShipName, sum(Quantity) desc)as row_number from Northwind.dbo.Orders o1 left join Northwind.dbo.[Order Details] o2 on o1.OrderID = o2.OrderID left join Northwind.dbo.Products p on o2.ProductID = p.ProductID where o1.ShipName is not null group by ShipName, CategoryID)
select * from added_row_number where row_number = 1;

--19
with added_row_number as (select c.ContactName, p.CategoryID, sum(Quantity) as Quantity, sum(o1.UnitPrice*Quantity*(1-Discount)) as total, row_number() over(partition by ContactName order by sum(Quantity) desc)as row_number from Northwind.dbo.[Order Details] o1 left join Northwind.dbo.Orders o2 on o1.OrderID = o2.OrderID left join Northwind.dbo.Customers c on c.CustomerID = o2.CustomerID left join Northwind.dbo.Products p on o1.ProductID = p.ProductID group by c.ContactName, p.CategoryID)
select * from added_row_number where row_number = 1;

--20
with added_row_number as (select c.ContactName, p.ProductName, sum(Quantity) as Quantity, row_number() over(partition by ContactName order by c.ContactName, sum(Quantity) desc)as row_number from Northwind.dbo.[Order Details] o1 left join Northwind.dbo.Orders o2 on o1.OrderID = o2.OrderID left join Northwind.dbo.Customers c on c.CustomerID = o2.CustomerID left join Northwind.dbo.Products p on o1.ProductID = p.ProductID group by c.ContactName, p.ProductName)
select * from added_row_number where row_number = 1;

--21
with added_row_number as (select City, ShippedDate, row_number() over(partition by City order by ShippedDate desc)as row_number from Northwind.dbo.[Order Details] o1 left join Northwind.dbo.Orders o2 on o1.OrderID = o2.OrderID left join Northwind.dbo.Customers c on o2.CustomerID = c.CustomerID)
select * from added_row_number where row_number = 1;

--22
select c.ContactName, sum(UnitPrice*Quantity*(1-Discount)) as total from Northwind.dbo.[Order Details] o1 left join Northwind.dbo.Orders o2 on o1.OrderID = o2.OrderID left join Northwind.dbo.Customers c on c.CustomerID = o2.CustomerID group by c.ContactName order by sum(UnitPrice*Quantity*(1-Discount)) desc offset 4 rows fetch next 1 rows only;
select c.ContactName, sum(UnitPrice*Quantity*(1-Discount)) as total from Northwind.dbo.[Order Details] o1 left join Northwind.dbo.Orders o2 on o1.OrderID = o2.OrderID left join Northwind.dbo.Customers c on c.CustomerID = o2.CustomerID group by c.ContactName order by sum(UnitPrice*Quantity*(1-Discount)) desc offset 9 rows fetch next 1 rows only;
select (select sum(UnitPrice*Quantity*(1-Discount)) as total from Northwind.dbo.[Order Details] o1 left join Northwind.dbo.Orders o2 on o1.OrderID = o2.OrderID left join Northwind.dbo.Customers c on c.CustomerID = o2.CustomerID group by c.ContactName order by sum(UnitPrice*Quantity*(1-Discount)) desc offset 4 rows fetch next 1 rows only)-(select sum(UnitPrice*Quantity*(1-Discount)) as total from Northwind.dbo.[Order Details] o1 left join Northwind.dbo.Orders o2 on o1.OrderID = o2.OrderID left join Northwind.dbo.Customers c on c.CustomerID = o2.CustomerID group by c.ContactName order by sum(UnitPrice*Quantity*(1-Discount)) desc offset 9 rows fetch next 1 rows only) as ª÷ÃB®t¶Z;
