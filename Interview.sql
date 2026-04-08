CREATE TABLE customers0204 (
    id INT,
    name VARCHAR(50)
);

INSERT INTO customers0204 (id, name) VALUES
(1, 'Asha'),
(2, 'Bala'),
(3, 'Chitra'),
(4, 'Deepak'),
(5, 'Esha'),
(6, 'Farhan');

CREATE TABLE orders0204 (
    order_id INT,
    cust_id INT
);

INSERT INTO orders0204 (order_id, cust_id) VALUES
(101, 1),
(102, 1),
(103, 3),
(104, 4),
(105, NULL);

/*02/04/2026*/

select * from customers0204;
select * from orders0204

/*Customers who have at least one order (EXISTS*/

SELECT C.*
FROM customers0204 c
WHERE EXISTS (
    SELECT 1
    FROM orders0204 o
    WHERE o.cust_id = c.id
);

/*Compare with IN (to see NULL issues)*/

SELECT C.*
FROM customers0204 c
WHERE id IN (
    SELECT cust_id
    FROM orders0204 o
);

/*Customers who do NOT have any orders (NOT EXISTS) */

SELECT C.*
FROM customers0204 c
WHERE NOT EXISTS (
    SELECT *
    FROM orders0204 o
    WHERE o.cust_id = c.id
);




CREATE TABLE letters (
    id INT,
    ch CHAR(1)
);

-- Insert data
INSERT INTO letters (id, ch) VALUES
(1, 'a'),
(2, 'b'),
(3, 'c'),
(4, 'd');


Select * from letters

/* polyndrome of the table*/

WITH base AS (
    SELECT id, ch
    FROM letters
),
rev AS (
    SELECT 
        (SELECT MAX(id) FROM letters) + ROW_NUMBER() OVER (ORDER BY id DESC) AS id,
        ch
    FROM letters
   
)
SELECT * FROM base
UNION ALL
SELECT * FROM rev

/* who didnt Place order */

select * from customers0204 C
left join  orders0204 o 
on c.id = o.cust_id
where  o.cust_id IS NULL


CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(50)
);

INSERT INTO products VALUES
(1, 'Laptop'),
(2, 'Mouse'),
(3, 'Keyboard'),
(4, 'Monitor');

CREATE TABLE sales (
    sale_id INT,
    product_id INT
);

INSERT INTO sales VALUES
(101, 1),
(102, 2),
(103, 2),
(104, 3),
(105, 2),
(106, 1);

select * from products 
select * from sales

/* Identify Most selling product*/ 

With T1 as
(
select Product_id,count(product_id) as P,DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
from sales
group by Product_id
)
select P.*,T1.P 
from products P
left join T1
on P.Product_id = T1.Product_id
where T1.rnk = 1

/* identify  most  selling product*/

CREATE TABLE Sales1 (
    sale_id INT,
    product_id INT,
    quantity INT
);

INSERT INTO Sales1 VALUES
(1, 1, 5),   -- Product 1 sold 5
(2, 2, 3),   -- Product 2 sold 3
(3, 1, 4),   -- Product 1 sold 4
(4, 3, 2),   -- Product 3 sold 2
(5, 2, 7),   -- Product 2 sold 7
(6, 4, 1);   -- Product 4 sold 1

Select * from Sales1

WIth T1 
as
(select top 1 product_id, sum(quantity) as T
from Sales1
group by product_id
order by T DESC
)
select P.product_name,T1.*
from products P
right join T1 on P.product_id = T1.product_id

CREATE TABLE Orders2 (
    order_id INT,
    customer_id INT
);

INSERT INTO Orders2 VALUES
(1, 101),
(2, 102),
(3, 101),
(4, 103),
(5, 101),
(6, 102),
(7, 101),
(8, 104),
(9, 101),
(10, 102),
(11, 105),
(12, 102),
(13, 102),
(14, 102),
(15, 106);

select * from Orders2

/* count how many customers placed more than 5 orders*/


select customer_id,count(order_id) as NO_orders
from Orders2 
group by customer_id
Having count(order_id) < 1

ALTER TABLE Orders2 ADD order_value DECIMAL(10,2);

UPDATE Orders2 SET order_value = 120.00 WHERE order_id = 1;
UPDATE Orders2 SET order_value = 80.00  WHERE order_id = 2;
UPDATE Orders2 SET order_value = 150.00 WHERE order_id = 3;
UPDATE Orders2 SET order_value = 60.00  WHERE order_id = 4;
UPDATE Orders2 SET order_value = 200.00 WHERE order_id = 5;
UPDATE Orders2 SET order_value = 90.00  WHERE order_id = 6;
UPDATE Orders2 SET order_value = 300.00 WHERE order_id = 7;
UPDATE Orders2 SET order_value = 110.00 WHERE order_id = 8;
UPDATE Orders2 SET order_value = 50.00  WHERE order_id = 9;
UPDATE Orders2 SET order_value = 180.00 WHERE order_id = 10;


/* Retrive customer orders with orders above average vlaue*/

select * from Orders2

select *
from  Orders2
where order_value > (select AVG(order_value) from Orders2)

/*find customers who placed orders every month in last 6 months give me data set... */

CREATE TABLE Orders4 (
    order_id INT,
    customer_id INT,
    order_date DATE
);

INSERT INTO Orders4 VALUES
-- Customer 101 (every month)
(1, 101, '2025-10-05'),
(2, 101, '2025-11-12'),
(3, 101, '2025-12-20'),
(4, 101, '2026-01-08'),
(5, 101, '2026-02-14'),
(6, 101, '2026-03-03'),

-- Customer 102 (missed December)
(7, 102, '2025-10-10'),
(8, 102, '2025-11-18'),
(9, 102, '2026-01-22'),
(10, 102, '2026-02-05'),
(11, 102, '2026-03-11'),

-- Customer 103 (only 2 months)
(12, 103, '2025-12-01'),
(13, 103, '2026-02-19'),

-- Customer 104 (every month)
(14, 104, '2025-10-07'),
(15, 104, '2025-11-25'),
(16, 104, '2025-12-15'),
(17, 104, '2026-01-09'),
(18, 104, '2026-02-28'),
(19, 104, '2026-03-16');

select * from Orders4

/*find customers who placed orders every month in last 6 months  */

WITH last6 AS (
    SELECT DATEADD(MONTH, -5, CAST(GETDATE() AS DATE)) AS start_date
),
monthly_orders AS (
    SELECT 
        customer_id,
        FORMAT(order_date, 'yyyy-MM') AS order_month
    FROM Orders4
    WHERE order_date >= (SELECT start_date FROM last6)
),
count_months AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT order_month) AS months_ordered
    FROM monthly_orders
    GROUP BY customer_id
)
SELECT customer_id
FROM count_months
WHERE months_ordered = 5;

/* 03/04/2026 */ 

select * from [dbo].[orders]

/*Find Moving average sales over last 3 days */

select Order_date,amount, 
AVG(amount) over( order by order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as MAvg_sales
from [orders]

select * from [dbo].[orders_audit]

/* find the last and first date of each customer */

select customer_id,product_id,order_date,
first_value(order_date) over( partition by customer_id order by order_date) FV,
last_value(order_date) over (partition by customer_id order by order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) as LV
from orders_audit 

/* retrieve customers who made consecutive purchase of 2 days*/


With T1 as
(
select customer_id,product_id,order_date,
Lead(order_date,1) over (partition by customer_id order by order_date) as ND 
from [dbo].[orders_audit]
)
select Customer_id,order_date,ND,DATEDIFF(DAY,order_date,ND) as DIFF
from T1
where DATEDIFF(DAY,order_date,ND) = 1


/* find customer who placed orders 6 motnhs ago- NO ORDERS IN LAST 6 MONTHS)*/

select * from orders_audit

select customer_id
from orders_audit
group by customer_id
having  MAX(order_date) < dateadd(month,-6,'2024-09-01' )

/* Churned Customers  in last 6 months */


Select * from orders_audit

With T1 as 
(
select customer_id
from orders_audit
group by customer_id
having max(order_date) < DATEADD(month,-6,'2024-09-30')
)
select * from orders_audit o
left join T1 on o.customer_id = T1.customer_id
order by o.customer_id


select * , datepart(month,cast(DATEADD(month,-6,order_date)as date)) as dd
from orders_audit

/* cumulative revenue by day */

select * , sum(amount) over ( order by order_date) as cumAmount
from orders_audit

/* Customers who ordered more than avg no of orders per customer*/

select * from orders_audit

With T1 as
(select customer_id, count(*) as NOrders
from orders_audit
group by customer_id
)
select customer_id from T1
where NOrders > (select AVG( NOrders) from T1)

With T1 as
(select customer_id, count(*) as NOrders
from orders_audit
group by customer_id
)
select  AVG(NOrders) as AV from T1

/* revenue from 1st generated orders */

Select * from orders_audit
order by customer_id

With T1 As
(select customer_id,min(order_date) as Forder
from orders_audit
group by customer_id
)
select sum(o.amount) as RevenU_Generated_1st_orders
from orders_audit o
right join T1 on T1.customer_id = o.customer_id 

/*Maximun order amount difference with in each employee */

select customer_id, Max(amount)- Min(amount) as diff
from orders_audit
group by customer_id

/* Active users over last 2 years 6 months */

Select count(distinct customer_id) as Active_Users
from orders_audit
where order_date >= DATEADD(month,-30,CAST(GETDATE() as DATE)) AND order_id is not null 

Select *, DATEADD(month,-24,GETDATE()) as AU from orders_audit

select * from [dbo].[emp]
left join [dbo].[employ]
using (emp_id)

/*08-082024*/

INSERT INTO emp (emp_id, emp_name, department_id, salary, manager_id)
VALUES
(1, 'Ankit', 1000, 10000, 4),
(2, 'Mohit', 1000, 15000, 5),
(3, 'Vikas', 1000, 10000, 4);













