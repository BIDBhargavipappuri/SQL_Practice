


 /* Write an SQL query to return the Top 3 Customers based on total spending in that month. */


With T1 AS
(
Select distinct customerID, Sum(Amount) over (partition by CustomerID ) as TSal
 from Salesdata
 )
select Top 3 customerID,TSal from T1
order by TSal DESC;
 









