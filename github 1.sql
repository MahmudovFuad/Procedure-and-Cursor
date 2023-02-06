------sql server cursor example calculating sum of price in procedure by date range


----creating table

CREATE TABLE [dbo].[product](
	[product_name] [nvarchar](20) NULL,
	[production_date] [date] NULL,
	[number] [int] NULL,
	[price] [decimal](9, 3) NULL,
	[city] [nvarchar](20) NULL
) ON [PRIMARY]
GO

---inserting data
insert into product(city,product_name,production_date,number,price)
values('Baku','Yoghurt','2020-01-01',100,2.550),
('Ankara','Tea','2020-05-02',150,10.500),
('Baku','Sausage','2021-03-19',240,13.75),
('Istanbul','Rice','2022-04-30',500,4.500),
('Ankara','Sugar','2019-07-19',660,5.500),
('Istanbul','Soap','2022-01-01',1000,11.30),
('Ankara','Waffles','2022-02-02',330,8.500),
('Istanbul','Fruit Juice','2021-03-01',2200,2.000),
('Baku','Alcohol','2022-05-05',1200,25.000),
('Ankara','Water','2022-10-10',900,1.800),
('Baku','Bread','2022-07-05',240,2.000),
('Istanbul','Cake','2023-09-18',465,3.700),
('Baku','Pasta','2018-07-01',1250,3.400),
('Ankara','Milk','2021-03-20',1345,2.800),
('Istanbul','Chip','2022-10-30',680,3.000)


---creating stored procedure

create  PROCEDURE product_sale
@start_date date,@finish_date date
AS
BEGIN
	SET NOCOUNT ON;
	---creating declare table for inserting distinct data for next select process
declare @x table(product_names nvarchar(20))
insert into @x(product_names)
select distinct product_name from product

declare @t table (city nvarchar(100),PRODUCT_NAMES nvarchar(100),NUMBER decimal(18,3))

declare @PRODUCT_NAMES nvarchar(100)declare cursor_results Cursor forselect PRODUCT_NAMES from @x ----opening cursor open cursor_results fetch next from cursor_results into @PRODUCT_NAMES while @@FETCH_STATUS=0begininsert into @t (city,PRODUCT_NAMES,NUMBER)select city,product_name ,sum(price) as cem from product where product_name=@PRODUCT_NAMES and (production_date between @start_date and @finish_date)group by product_name,cityfetch next from cursor_results into @PRODUCT_NAMES end---closing cursorclose cursor_results;deallocate cursor_results;

select * from @t
END
GO

---testing our stored procedure 
exec dbo.product_sale '2020-01-01','2022-12-12'