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

WITH dt As