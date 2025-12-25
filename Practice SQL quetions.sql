create table sales_data
(source_system  varchar(50),
  business_unit varchar(50),
   apr_2025  int,
    may_2025  int,
    jun_2025 int)

insert into sales_data values ( 'SS1', 'BU1',120,130,110),
                       ( 'SS2', 'BU1',200,210,220),
                       ( 'SS1', 'BU2',100,95,105),
                       ( 'SS3', 'BU3',150,160,155);


                       select * from sales_data

select source_system, business_unit , ( apr_2025+ may_2025+jun_2025) / 3  as Su
from  sales_data

 /* count employess in each department having more than 5 employess */

 Select * from dbo.DimEmployee  

 select departmentname , count(*)
 from dbo.DimEmployee
 group by departmentname
 having count(*) >5 



 select * from dbo.DimEmployee
 where HireDate >= DATEADD(month,-6,GETDATE())

 /*Get department with no employees */

 Select departmentname,EmployeeKey 
 from  dbo.DimEmployee
 where EmployeeKey  IS  NULL 


 /* write a query to find median salary/BaseRate */ 


select top 1 PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY BaseRate) OVER () AS Median
FROM dbo.DimEmployee

/* Correct Query */

SELECT distinct
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CAST(BaseRate AS FLOAT)) 
    OVER () AS Median
FROM (
    SELECT DISTINCT CAST(BaseRate AS FLOAT) AS BaseRate
    FROM dbo.DimEmployee
) AS CleanRates;

/*  query to get data type of column */

SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimEmployee' AND COLUMN_NAME = 'BaseRate';

/* Running totoal of salaries by department */

select *, sum(Salaray) over (partition by Dep_id order by Emp_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as run_total from [dbo].[Emp_table] 


select * from [dbo].[Purchases]

/*Calculate the Rolling 7-Day Average of Daily Sales, */

select * , sum(Amount) Over (order by OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) as running_total from Salesdata

/* Find Orders Where the Total Quantity Exceeds 100 Units
Table: Order_Details(order_id, product_id, quantity)*/

Select * from Purchases
where amount >= 100

CREATE TABLE orders (
    order_id INT,
    product_id INT
);

INSERT INTO orders (order_id, product_id) VALUES
(1, 101), (1, 102), (1, 103),
(2, 101), (2, 102),
(3, 102), (3, 103),
(4, 101), (4, 103),
(5, 101), (5, 102),
(6, 102), (6, 103),
(7, 101), (7, 102),
(8, 101), (8, 103),
(9, 102), (9, 103),
(10, 101), (10, 102);

select *  from orders



WITH ProductPairs AS (SELECT  o1.order_id,
        o1.product_id AS product_A,
        o2.product_id AS product_B
    FROM orders o1
    JOIN orders o2 
        ON o1.order_id = o2.order_id 
        AND o1.product_id < o2.product_id
        )
SELECT 
    product_A,
    product_B,
    COUNT(*) AS times_bought_together
FROM ProductPairs
GROUP BY product_A, product_B
HAVING COUNT(*) > 2
ORDER BY times_bought_together DESC;









 

