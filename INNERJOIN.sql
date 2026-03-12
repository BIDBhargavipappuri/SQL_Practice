CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    amount INT
);

INSERT INTO orders (order_id, customer_id, order_date, amount) VALUES
(1, 101, '2024-04-01', 100),
(2, 102, '2024-05-01', 200),
(3, 101, '2024-06-01', 150);

CREATE TABLE customers_history (
    customer_id INT,
    country VARCHAR(10),
    effective_date DATE,
    end_date DATE
);

INSERT INTO customers_history (customer_id, country, effective_date, end_date) VALUES
(101, 'US', '2023-01-01', '2024-05-01'),
(101, 'UK', '2024-05-02', NULL),
(102, 'CA', '2023-06-01', NULL);

SELECT
    c.country,
    SUM(o.amount) AS revenue
FROM orders o
JOIN customers_history c
    ON o.customer_id = c.customer_id
    AND o.order_date >= c.effective_date
    AND (c.end_date IS NULL OR o.order_date <= c.end_date)
GROUP BY c.country;