---Discount Effects
---Using SampleRetail database generate a report, including product IDs 
---and discount effects on whether the increase in the discount rate 
---positively impacts the number of orders for the products.
---For this, statistical analysis methods can be used. However, 
---this is not expected.
---In this assignment, you are expected to generate a solution using 
---SQL with a logical approach. 

select distinct product_id
from [sale].[order_item]

WITH dt As(SELECT  product_id,             discount,            COUNT(order_id) AS count_order,            LAG(COUNT(order_id)) OVER (PARTITION BY product_id ORDER BY discount) as prev_order,            COALESCE((COUNT(order_id) - LAG(COUNT(order_id)) OVER (PARTITION BY product_id ORDER BY discount)),0) as diff_in_order    FROM sale.order_item oi    GROUP BY product_id, discount    )SELECT dt.product_id,   CASE    WHEN SUM(dt.diff_in_order) = 0 THEN 'neutral'   WHEN SUM(dt.diff_in_order) > 0 THEN 'positive'   ELSE 'negative' END AS Discount_effectFROM dtGROUP BY dt.product_id;
