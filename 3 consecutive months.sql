WITH MonthlyPurchases AS (
    SELECT 
        user_id,
        MONTH(purchase_date) AS purchase_month
    FROM Purchases
    GROUP BY user_id, MONTH(purchase_date)
),
RankedMonths AS (
    SELECT 
        user_id,
        purchase_month,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY purchase_month) AS rn
    FROM MonthlyPurchases
),
ConsecutiveCheck AS (
    SELECT 
        a.user_id,
        a.purchase_month AS month1,
        b.purchase_month AS month2,
        c.purchase_month AS month3
    FROM RankedMonths a
    JOIN RankedMonths b ON a.user_id = b.user_id AND a.rn = b.rn - 1
    JOIN RankedMonths c ON a.user_id = c.user_id AND a.rn = c.rn - 2
    WHERE 
        b.purchase_month = a.purchase_month + 1
        AND c.purchase_month = a.purchase_month + 2
)
SELECT DISTINCT user_id
FROM ConsecutiveCheck;