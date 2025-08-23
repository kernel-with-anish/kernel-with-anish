-- Monthly Revenue
WITH line_items AS (
  SELECT o.order_date, o.quantity*p.unit_price AS line_rev
  FROM orders o JOIN products p ON o.product_id=p.product_id
  WHERE o.status='Completed'
)
SELECT strftime('%Y-%m', order_date) AS month, SUM(line_rev) AS revenue
FROM line_items GROUP BY month;

-- Top Products
WITH ranked AS (
  SELECT p.product_name, SUM(o.quantity*p.unit_price) AS revenue,
         RANK() OVER(ORDER BY SUM(o.quantity*p.unit_price) DESC) AS rnk
  FROM orders o JOIN products p ON o.product_id=p.product_id
  WHERE o.status='Completed'
  GROUP BY product_name
)
SELECT * FROM ranked WHERE rnk <= 10;
