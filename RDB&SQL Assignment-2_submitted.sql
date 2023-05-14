---1. Product Sales
---You need to create a report on whether customers who purchased the product
--named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.

---1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)

select  sc.customer_id  , sc.first_name, sc.last_name, 
case when p.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'  And p.product_name = 'Polk Audio - 50 W Woofer - Black' then 'Yes' else 'No' end AS other_product 
FROM [sale].[customer] sc
inner join [sale].[orders] so on sc.customer_id= so.customer_id 
inner join [sale].[order_item] si on si.order_id= so.order_id 
inner join [product].[product] p on p.product_id = si.product_id
where so.customer_id in 
(
select so.customer_id
from [sale].[orders] so
where p.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' AND p.product_name != 'Polk Audio - 50 W Woofer - Black' 
)
order by customer_id asc


---2. Conversion Rate
---Below you see a table of the actions of customers visiting the website 
---by clicking on two different types of advertisements given by an 
---E-Commerce company. Write a query to return the conversion rate for
---each Advertisement type.

---a.    Create above table (Actions) and insert values,
CREATE DATABASE E_Commerce 

CREATE SCHEMA Actions;

CREATE TABLE Actions(
    Visitor_ID int PRIMARY KEY  NOT NULL,
    Adv_Type varchar(50) NOT NULL,
    Action_type varchar(50)NOT NULL,
);
INSERT INTO Actions  (
    Visitor_ID,
    Adv_Type,
    Action_type
)
   VALUES
    (1, 'A', 'left'),
    (2, 'A', 'Order'),
    (3, 'B', 'left'),
    (4, 'A', 'Order'),
    (5, 'A', 'Review'),
    (6, 'A', 'left'),
	(7, 'B', 'left'),
	(8, 'B', 'Order'),
	(9, 'B', 'Review'),
	(10, 'A','Review'
	);


SELECT * 
FROM dbo.Actions

-----b.Retrieve count of total Actions and Orders for each Advertisement Type,

SELECT
  Adv_Type,
  SUM(CASE
    WHEN Action_type = 'Order'  THEN 1
    ELSE 0 END) as Orders
FROM Actions
GROUP BY Adv_Type;


SELECT
  Adv_Type,
  SUM(CASE 
	WHEN Action_type!= 'Order' THEN 1
    ELSE 0 END) as total_actions 
FROM Actions
GROUP BY Adv_Type;




---c.Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total 
------count of actions casting as float by multiplying by 1.0.


SELECT Adv_Type, SUM(CASE
    WHEN Action_type = 'Order'  THEN 1
    ELSE 0 END)/SUM(CASE 
	WHEN Action_type!= 'Order' THEN 1
    ELSE 0 END) as Conversion_Rate
FROM Actions
GROUP BY Adv_Type;


























---a.    Create above table (Actions) and insert values,








---b.    Retrieve count of total Actions and Orders for each Advertisement Type,







---c.    Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.



