---- RDB&SQL E-Commerce Data Analysis Project (DS 05/23 DE EN) 
---E-Commerce Data and Customer Retention Analysis with SQL
---1 create a database and import into the given csv file. 
CREATE DATABASE E_commerce

---1. Find the top 3 customers who have the maximum count of orders.
SELECT TOP 3 Customer_Name, COUNT(Ord_ID) AS Order_Count 
FROM e_commerce_data
GROUP BY Customer_Name
ORDER BY Order_Count  DESC
-------------
----2. Find the customer whose order took the maximum time to get shipping.

WITH TD as
	(Select Customer_Name , DATEDIFF(DAY, order_date,Ship_Date) DAY_DIFF
	from e_commerce_data)
	SELECT TOP 1 Customer_Name,  MAX(DAY_DIFF) Max_Time_Shipping
    FROM TD
	group by [Customer_Name]
	Order by Max_Time_Shipping DESC;

---3. Count the total number of unique customers in January and how many of them
---came back every month over the entire year in 2011
With January AS
(
      SELECT DISTINCT Cust_ID
      FROM e_commerce_data
      WHERE month(Order_Date)= 11
      AND  year(Order_Date)=2011
	  )
	  SELECT Year(Order_Date) as Year,
       Month(Order_Date) AS Month,
       count (distinct e.Cust_ID) AS number
FROM e_commerce_data e, January j

WHERE year(Order_Date)=2011
AND e.Cust_ID = j.Cust_ID
GROUP BY j.Cust_ID;



----4. Write a query to return for each user the time elapsed between the first
---purchasing and the third purchasing, in ascending order by Customer ID.
WITH CTE AS 
(SELECT DISTINCT Cust_ID, 
        Order_Date, 
     Lead(Order_Date,2) OVER (PARTITION BY Cust_ID ORDER BY  Cust_ID ASC) AS Third_Order_date
     
     FROM e_commerce_data
	Group by Cust_ID,Order_Date
	     )
		  
SELECT Cust_ID, 
       Order_Date, 
      Third_Order_date,
      Datediff(month,Order_Date, Third_Order_date) AS Interval_1st_3nd
FROM CTE

ORDER BY Cust_ID

---5.Write a query that returns customers who purchased both product 11 and
---product 14, as well as the ratio of these products to the total number of
---products purchased by the customer.
	With TD AS	
	(Select Customer_Name, Prod_ID as Prod_11
	from e_commerce_data
	Where Prod_ID = 'Prod_11'
	
	)
	   	(SELECT DISTINCT TD.Customer_Name 
		from e_commerce_data,TD
		Where Prod_ID ='Prod_14' 
		ANd e_commerce_data.Customer_Name =TD.Customer_Name)
	With TD2 AS
	(Select Customer_Name ,(sum(case when Prod_id = 'Prod_11' then 1 else 0 end)/
		 (case when Prod_id = 'Prod_14' then 1 else 0 end)) As Ratio
	from e_commerce_data
    where Prod_id in ('Prod_11', 'Prod_14')
	  )





---Customer Segmentation
---Categorize customers based on their frequency of visits. The following steps
---will guide you. If you want, you can track your own way.

---1. Create a “view” that keeps visit logs of customers on a monthly basis. (For
---each log, three field is kept: Cust_id, Year, Month)

With Visit_log AS
(SELECT Cust_id,Year(Order_Date), Month(Order_Date),
       datediff(month,YEAR ,  Order_Date) AS visit_month
FROM e_commerce_data
)
with Time_lapse AS
    SELECT Cust_id,
           visit_month lead(visit_month, 1) over (partition BY cust_id ORDER BY cust_id, visit_month)
    FROM visit_log
	)
	
Time_diff_calculated AS
    SELECT cust_id,
           visit_month,
           lead,
           lead — visit_month AS time_diff
    FROM time_lapse


---2. Create a “view” that keeps the number of monthly visits by users. (Show
---separately all months from the beginning business)
---window fun

SELECT distinct Cust_id,count(Month(Order_Date))AS number
FROM e_commerce_data
WHERE year(Order_Date) =year(Order_Date)
GROUP BY 1, 2




---3. For each visit of customers, create the next month of the visit as a separate
---column.

SELECT  Cust_ID, 
        Order_Date,
		year(Order_Date) Year,
            LEAD(month(Order_Date)) OVER (PARTITION BY Cust_ID ORDER BY month(Order_date)) as Next_order_month
    FROM e_commerce_data;
	
---4. Calculate the monthly time gap between two consecutive visits by each
---customer.
SELECT  Cust_ID, 
        Order_Date,
		
           LEAD(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY month(Order_date)) ,
		   COALESCE(month(Order_Date) - LAG(Month(Order_Date)) OVER (PARTITION BY Cust_ID ORDER BY Month(Order_date)),0) as diff_in_order
	FROM e_commerce_data;	
	

---5. Categorise customers using average time gaps. Choose the most fitted
---labeling model for you.
---For example:
---o Labeled as churn if the customer hasn't made another purchase in the
---months since they made their first purchase.
---o Labeled as regular if the customer has made a purchase every month.
With CT AS
(SELECT Cust_ID, Order_Date,month(Order_date) As month
			
           Order_Date - LAG(Month(Order_Date)) OVER (PARTITION BY Cust_ID ORDER BY Month(Order_date)),0) as diff_in_order
		FROM e_commerce_data
		)
	
		Select AVG(TD.diff_in_order) As Average
		FROM CT
		Group by Cust_ID;




---Month-Wise Retention Rate
---Find month-by-month customer retention ratei since the start of the business.
---There are many different variations in the calculation of Retention Rate. But we will
---try to calculate the month-wise retention rate in this project.
---So, we will be interested in how many of the customers in the previous month could
---be retained in the next month.
---Proceed step by step by creating “views”. You can use the view you got at the end of
---the Customer Segmentation section as a source.


---1. Find the number of customers retained month-wise. (You can use time gaps)



---2. Calculate the month-wise retention rate.
---Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total
---Number of Customers in the Current Month

