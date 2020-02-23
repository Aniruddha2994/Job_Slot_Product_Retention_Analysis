--Data Assignment: Part A

--#1 This query gives the total contract value for each state by month. FOr month I have used the StartDate months.

SELECT loc.State_Name, 
	   sp2.MONth, 
	   SUM(sp1.Total_Contract_Value) as Total_Contract_Value 
FROM sales_performance_data sp1
LEFT JOIN (SELECT Employer_ID, 
				  City_ID, Contract_ID, 
				  substr(StartDate, 4,2) as Month
		   FROM sales_performance_data) sp2
	ON sp1.Employer_ID = sp2.Employer_ID 
    AND sp1.City_ID = sp2.City_ID 
	AND sp1.Contract_ID = sp2.Contract_ID
LEFT JOIN locatiON_data loc
	ON sp1.City_ID = loc.City_ID
GROUP BY sp2.MONth, loc.State_ID, loc.State_Name
ORDER BY loc.State_Name ASC;


--This query gives the 2nd purchase's Job-slots and total contract value for every partner with >1 product purchase
--Assumption: Contract_ID refers to each purchase and also considering renewals as a new purchase.
SELECT t.Employer_ID,
	   t.StartDate, 
	   t.Job_Slots, 
	   t.Click_Market_Value 
FROM(
	SELECT sp.Employer_ID, 
		   sp.StartDate, 
		   sp.Job_Slots, 
		   sp.Click_Market_Value, 
		   Rank() OVER(PARTITION BY sp.Employer_ID ORDER BY sp.Year,sp.Month,sp.days ASC) as ranking
	FROM (
		  SELECT Employer_ID, 
				 StartDate, 
				 Job_Slots,
				 Click_Market_Value, 
				 substr(SartDate, 4,2) as MONth, 
				 substr(SartDate, 7,4) as year,  
				 substr(SartDate, 1,2) as days
		  FROM sales_performance_data) sp
		  WHERE ranking = 2
	) as t






