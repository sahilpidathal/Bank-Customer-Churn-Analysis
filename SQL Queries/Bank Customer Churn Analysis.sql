Create Database BankCustomerChurnDB;

use BankCustomerChurnDB;

-- Droping table Bcoz we already have table in our dataset 
DROP TABLE Customer_Churn;
--Result: Delete tabale

--table view
select * from Churn_Modelling;		
--Result tabular format of the data

-- for records veriying 
select COUNT(*) as TotalCustomers
FROM Churn_Modelling;
-- result: 10000 records verified

-- Count total exited customers from the bank
select count(*) as TotalExited
from Churn_Modelling
where Exited = 1;
-- result: 2037

--calculating Churn Rate 
select 
cast(
count(*)*100.0/
(select count(*) from Churn_Modelling) 
as decimal(5,2)
) as ChurnRateOfExited
from Churn_modelling
where Exited = 1;
-- Result: 20.37% 

--count total customers are still with the bank
select count(*) as TotalStayed
from Churn_Modelling
where Exited = 0;
-- result: 7963

--Counting Total customer from each Country
select Geography,count(*) as TotalCustomers
from Churn_Modelling
group by Geography
order by TotalCustomers desc;
/*
Result:
	|Geography|TotalCustomer|	
	|France	  |5014			|
	|Germany  |2509         |
	|Spain	  |2477			|
*/

--Counting Exited customer from each country
select geography, count(*) as ExitedCustomer
from Churn_Modelling
Where Exited = 1
group by Geography
order by ExitedCustomer desc;
/*
Result:
	|Geography|ExitedCustomer|	
	|Germany  |814	   	     |
	|France   |810           |
	|Spain	  |413	         |
*/

-- Calculating Average Credit Score from each country
select Geography,
cast(avg(CreditScore) as decimal(6,2)) 
as AvgCreditScore
from Churn_Modelling
group by Geography
order by AvgCreditScore Desc;
/*
Result:
	|Geography|AvgCreditScore|	
	|Germany  |651.00	     |
	|Spain	  |651.00	     |
	|France   |649.00        |
*/

-- For each country, how many customers stayed and how many exited?
select 
Geography, 
sum ( case when Exited = 0 then 1 else 0 end) as StayedCustomer,
sum ( case when Exited = 1 then 1 else 0 end) as ExitedCustomer
from Churn_Modelling
group by Geography;
/*
Result:
	|Geography|StayedCustomer|ExitedCustomer|	
	|Germany  |1695	   	     |814           |
	|France   |4204          |810           |
	|Spain	  |2064	         |413           |
*/

--How many male and female customers are there?
select gender, count(*) as TotalCustomer
from Churn_Modelling
group by Gender;
/*
Result:
	|Gender|TotalCustomer|
	|Male  |5457		 |
	|Female|4543		 |
*/

--How many male and female customers have exited the bank?
select 
Gender,
count(*) as ExitedCustomers
from Churn_Modelling
where Exited = 1
group by Gender
order by ExitedCustomers desc;
/*
Result:
	|Gender|ExitedCustomers|
	|Female|1139		   |
	|Male  |898		       |
*/

--Calculate the churn rate for each gender.
select Gender,
count(*) as TotalCustomers,
sum (case
	when Exited = 1 then 1 else 0 
	end
	) as ExitedCustomers,
cast(
	 sum(case when Exited = 1 then 1 else 0 end)*100.0 /
	 count(*) as decimal (5,2)) as ChurnRate
from Churn_Modelling
group by Gender
order by ChurnRate desc;
/*
Result:
	|Gender|TotalCustomers|ExitedCustomers|ChurnRate|
	|Female|4543		  |1139           |25.07    |
	|Male  |5457		  |898		      |16.46    |
*/

--How many customers belong to each Age Group?
select
(case 
		when Age<=30 then 'Young Adult'
		when Age<=40 then 'Adult'
		when Age<=50 then 'Middle Aged'
		when Age<=60 then 'Senior Adult'
		else 'Senior Citizen'
		End)
		as AgeGroup,
count(*) TotalCustomers 
from Churn_Modelling
group by 
	case 
		when Age<=30 then 'Young Adult'
		when Age<=40 then 'Adult'
		when Age<=50 then 'Middle Aged'
		when Age<=60 then 'Senior Adult'
		else 'Senior Citizen'
		End
order by TotalCustomers desc;	
/*
Result:
	|AgeGroup      |TotalCustomers|
	|Adult         |4451		  |
	|Middle Aged   |2320		  |		
	|Young Adult   |1968		  |
	|Senior Adult  |797  		  |
	|Senior Citizen|464		      |
*/

--How many customers exited from each Age Group?
select 
( case 
	when Age<=30 then 'young adult'
	when Age<=40 then 'adult'
	when Age<=50 then 'middle aged'
	when Age<=60 then 'senior adult'
	else 'senior citizen'
	end
	) as AgeGroup,
count(*) as ExitedCustomer
from Churn_Modelling
where Exited = 1
group by
case 
	when Age<=30 then 'young adult'
	when Age<=40 then 'adult'
	when Age<=50 then 'middle aged'
	when Age<=60 then 'senior adult'
	else 'senior citizen'
	end
order by ExitedCustomer desc;
/*
Result:
	|AgeGroup      |ExitedCustomers|
	|Middle Aged   |788		       |		
	|Adult         |538		       |
	|Senior Adult  |448  		   |
	|Young Adult   |148		       |
	|Senior Citizen|115		       |
*/

--Churn Rate by Age Group
select 
(case 
	when Age<=30 then 'young adult'
	when Age<=40 then 'adult'
	when Age<=50 then 'middle aged'
	when Age<=60 then 'senior adult'
	else 'senior citizen'
	end
)as AgeGroup,
count(*) as TotalCustomer,
sum (
	case when Exited = 1 then 1 else 0 end
) as ExitedCustomer,
cast( sum(
		case When Exited =1 then 1 else 0 end)*100.0/
		count(*) as decimal (5,2)) as ChurnRate
from Churn_Modelling
group by 
case 
	when Age<=30 then 'young adult'
	when Age<=40 then 'adult'
	when Age<=50 then 'middle aged'
	when Age<=60 then 'senior adult'
	else 'senior citizen'
	end
order by ChurnRate desc;
/*
Result:
	|AgeGroup	   |TotalCustomers|ExitedCustomers|ChurnRate|
	|Senior Adult  |797  		  |448            |56.21    |
	|Middle Aged   |2320          |788            |33.97    |
	|Senior Citizen|464		      |115            |24.78    |
	|Adult         |4451		  |538            |12.09    |
	|Young Adult   |1968		  |148            |7.52     |
*/

--What is the average account balance for customers in each country?
select Geography,
cast(
	Avg(Balance) as decimal (8,2)) as AvgBalance
from Churn_Modelling
group by Geography
Order by AvgBalance desc;
/*
Result:
	|Geography|AvgBalance|
	|Germany  |119730.12 |
	|France   |62092.64  |
	|Spain	  |61818.15  |
*/

--What is the average account balance for each Age Group?
select 
(case 
	when Age<=30 then 'young adult'
	when Age<=40 then 'adult'
	when Age<=50 then 'middle aged'
	when Age<=60 then 'senior adult'
	else 'senior citizen'
	end
)as AgeGroup,
round(avg(Balance),2)as AvgBalance
from Churn_Modelling
group by 
case 
	when Age<=30 then 'young adult'
	when Age<=40 then 'adult'
	when Age<=50 then 'middle aged'
	when Age<=60 then 'senior adult'
	else 'senior citizen'
	end
order by AvgBalance desc;
/*
Result:
	|AgeGroup      |AvgBalance|
	|Senior Adult  |82401.66  |
	|Middle Aged   |79122.19  |		
	|Senior Citizen|75742.6	  | 
	|Adult         |75583.36  |
	|Young Adult   |73198.76  |
*/

--How many customers have a balance of exactly ₹0 (or 0 in the dataset)?
select count(*)as ZeroBalanceCustomers
from Churn_Modelling
where Balance = 0;
--Result: 3617 customers have 0 Balance

--What is the churn rate for customers with a zero account balance?
select
count(*) as ZeroBalanceCustomers,
sum(
	case
		when Exited =1 then 1 else 0 
		end 
	)as ExitedCustomers,
cast(sum
	(case when Exited = 1 then 1 else 0 end)*100.0/count(*) as decimal (5,2)
)as ChurnRate
from Churn_Modelling
where Balance = 0;
/*
Result:
	|ZeroBalanceCustomers|ExitedCustomers|ChurnRate|
	|3617                |500            |13.82    |
*/

--Classify customers into Balance Categories and count how many customers fall into each category.
select 
case 
	when Balance<=0 then 'Zero Balance'
	when Balance<=50000 then 'Low Balance'
	when Balance<=100000 then 'Medium Balance'
	else 'High Balance'
	end
	as 'Balance Category',
count(*) as 'Total Customers'
from Churn_Modelling
group by 
case 
	when Balance<=0 then 'Zero Balance'
	when Balance<=50000 then 'Low Balance'
	when Balance<=100000 then 'Medium Balance'
	else 'High Balance'
	end
order by 'Total Customers' desc;
/*
Result:
	|Balance Category|Total Customers|
	|High Balance    |4799		     |
	|Zero Balance    |3617           |
	|Medium Balance  |1509		     | 
	|Low Balance     |75			 |		
*/

--What is the churn rate for each Balance Category?
select 
case 
	when Balance<=0 then 'Zero Balance'
	when Balance<=50000 then 'Low Balance'
	when Balance<=100000 then 'Medium Balance'
	else 'High Balance'
	end
	as 'Balance Category',
count(*) as 'Total Customers',
sum(
	case when Exited =1 then 1 else 0
	end)as 'Total Exited Customers',
cast 
	(sum
		(case when Exited =1 then 1 else 0
		end)*100.0/
		count(*) as decimal (5,2)
		) as 'Churn Rate'
from Churn_Modelling
group by 
	case 
		when Balance<=0 then 'Zero Balance'
		when Balance<=50000 then 'Low Balance'
		when Balance<=100000 then 'Medium Balance'
		else 'High Balance'
	end
order by 'Churn Rate' desc;
/*
Result:
	|Balance Category|Total Customers|Total Exited Customers|Churn Rate|
	|High Balance    |4799		     |1211					|25.23     |
	|Zero Balance    |3617           |500                   |13.82     |
	|Medium Balance  |1509		     |300                   |19.88     |
	|Low Balance     |75			 |26		            |34.67     |
*/
 
 --How many customers have 1, 2, 3, or 4 bank products?
 select NumOfProducts ,count(*) as TotalCustomers
 from Churn_Modelling
 group by NumOfProducts
 order by NumOfProducts desc;
 /*
 Result:
	|NumofProducts|TotalCustomers|
	|1			  |5084			 |
	|2			  |4590			 |
	|3			  |266			 |
	|4			  |60			 |
*/

--What is the churn rate for customers with 1, 2, 3, and 4 products?
select
NumOfProducts ,
count(*) as TotalCustomers,
sum (
	case when Exited = 1 then 1 else 0
	end) as ExitedCustomers,
cast (
	sum(
		case when Exited = 1 then 1 else 0
		end)*100.0/
		count(*) as decimal (5,2)
		) as ChurnRate
from Churn_Modelling
group by NumOfProducts
order by NumOfProducts;
/*
Result:
	|NumOfProducts|Total Customers|Total Exited Customers|Churn Rate|
	|1            |5084	   	      |1409					 |27.71     |
	|2			  |4590           |348                   |7.58      |
	|3			  |266		      |220                   |82.71     |
	|4			  |60			  |60		             |100.00    |
*/

-- for verifying product for has 60 exited customers is correct or wrong
SELECT
    NumOfProducts,
    Exited,
    COUNT(*) AS Customers
FROM Churn_Modelling
WHERE NumOfProducts = 4
GROUP BY NumOfProducts, Exited;
--Result: it is correct it hase 60 customers exited

--How many customers have a credit card and how many do not?
select 
HasCrCard,count(*) as TotalCustomers
from Churn_Modelling
group by HasCrCard
order by HasCrCard;
/*
Result:
	|HasCrCard|TotalCustomers|
	|0		  |2945			 |
	|1		  |7055			 |
*/

--What is the churn rate for customers who have a credit card versus those who do not?
select 
HasCrCard,
count(*) as TotalCustomers,
sum (
	case 
		when Exited = 1 then 1 else 0 
		end) as ExitedCustomers,
cast (
	sum(
		case 
			when Exited = 1 then 1 else 0 
			end)*100.0/
			count(*) as decimal (5,2) 
		) as ChurnRate
from Churn_Modelling
group by HasCrCard
order by HasCrCard;
/*
Result:
	|HasCrCard|TotalCustomers|ExitedCustomers|ChurnRate|
	|0        |2945	   	     |613			 |20.81     |
	|1		  |7055          |1424           |20.18     |
*/

--How many customers are active members and how many are inactive?
select 
	case when IsActiveMember= 1 then 'ActiveCustomers'
		else 'InactiveCustomers' 
		end as 'Active/Inactive',
	count(*) as TotalCustomers
from Churn_Modelling
group by 
	case 
		when IsActiveMember= 1 then 'ActiveCustomers'
		else 'InactiveCustomers' 
	end 
order by TotalCustomers desc;
/* 
Result:
	|Active/Inactive  |TotalCustomers|
	|ActiveCustomers  |5151			 |
	|InactiveCustomers|4849			 |
*/

--What is the churn rate for Active vs Inactive customers?
select 
	case when IsActiveMember= 1 then 'ActiveCustomers'
		else 'InactiveCustomers' 
		end as MemberStatus,
count(*) as TotalCustomers,
sum(
	case
		when Exited= 1 then 1	else 0 
		end) as ExitedCustomers,
cast(
	sum(	
		case 
			when Exited = 1 then 1 else 0 
		end)*100.0 / 
		count(*) as decimal (5,2)
		)as ChurnRate
from Churn_Modelling
group by 
	case 
		when IsActiveMember= 1 then 'ActiveCustomers'
		else 'InactiveCustomers' 
	end 
order by ChurnRate desc;
/*
Result:
	|MemberStatus     |TotalCustomers|ExitedCustomers|ChurnRate|
	|InactiveCustomers|4849          |1302           |26.85    |
	|ActiveCustomers  |5151	   	     |735  			 |14.27    |
*/

--How many customers belong to each Credit Score category?
select 
case 
	when CreditScore <=500 then 'poor'
	when CreditScore <=650 then 'fair'
	when CreditScore <=750 then 'good'
	else 'excellent'
end as CreditCategory,
count(*) TotalCustomers
from Churn_Modelling
group by 
case 
	when CreditScore <=500 then 'poor'
	when CreditScore <=650 then 'fair'
	when CreditScore <=750 then 'good'
	else 'excellent'
end
order by TotalCustomers desc;
/*
Result:
	|CreditCategory|TotalCustomers|
	|fair		   |4294		  |
	|good		   |3465		  |
	|excellent	   |1598		  |
	|poor          |643			  |
*/

--What is the churn rate for each Credit Score category?
select 
case 
	when CreditScore <=500 then 'poor'
	when CreditScore <=650 then 'fair'
	when CreditScore <=750 then 'good'
	else 'excellent'
end as CreditCategory,
count(*) TotalCustomers,
sum(
	case 
		when Exited = 1 then 1 else 0
		end)as ExitedCustomers,
cast(
	sum(
		case
			when Exited =1 then 1 else 0 end)*100.0/
			count(*) as decimal (5,2) 
			) as ChurnRate
from Churn_Modelling
group by 
case 
	when CreditScore <=500 then 'poor'
	when CreditScore <=650 then 'fair'
	when CreditScore <=750 then 'good'
	else 'excellent'
end
order by ChurnRate desc;
/*
Result:
	|CreditCategory|TotalCustomers|ExitedCustomers|ChurnRate|
	|poor          |643			  |152			  |23.64    |
	|fair		   |4294		  |905			  |21.08	|
	|excellent	   |1598		  |313			  |19.59	|
	|good		   |3465		  |667			  |19.25	|
*/

--How many customers belong to each tenure (0–10 years)?
select 
Tenure,
count(*) TotalCustomers
from Churn_Modelling
group by Tenure
order by Tenure;
/*
Result:
	|Tenure|TotalCustomer|
	|0	   |413			 |
	|1	   |1035		 |
	|2	   |1048		 |
	|3	   |1009		 |
	|4	   |989			 |
	|5	   |1012		 |
	|6	   |967			 |
	|7	   |1028		 |
	|8	   |1025		 |
	|9	   |984			 |
	|10	   |490			 |
*/

--What is the churn rate for each tenure (0–10 years)?
select 
Tenure,
count(*) as TotalCustomers,
sum( 
	case 
		when Exited = 1 then 1 else 0 
	end ) as ExitedCustomers,
cast(sum(
		case
			when Exited = 1 then 1 else 0 end)*100.0/ count(*) as decimal(5,2)
			) as ChurnRate
from Churn_Modelling
group by Tenure
order by Tenure;
/*
Result:
	|Tenure|TotalCustomer|ExitedCustomers|ChurnRate|
	|0	   |413			 |95			 |23.00	   |
	|1	   |1035		 |232			 |22.42    | 
	|2	   |1048		 |201			 |19.18    |
	|3	   |1009		 |213			 |21.11    |
	|4	   |989			 |203			 |20.53    |
	|5	   |1012		 |209			 |20.65    |
	|6	   |967			 |196			 |20.27    |
	|7	   |1028		 |177			 |17.22    | 
	|8	   |1025		 |197			 |19.22    |
	|9	   |984			 |213			 |21.65    |
	|10	   |490			 |101			 |20.61    |
*/

--What is the average estimated salary for customers in each country?
select 
Geography,
round(
	avg(EstimatedSalary), 2) as AvgSalary
from Churn_Modelling
group by Geography
order by AvgSalary desc;
/*
Result:
	|Geography|AvgSalary|
	|Germany  |101113.44|
	|France   |99899.18 |
	|Spain    |99440.57 |
*/

--Classify customers into Salary Categories and count how many customers fall into each category.
select 
	case
		when EstimatedSalary <= 50000 then 'Low Salary'
		when EstimatedSalary <= 100000 then 'Medium Salary'
		when EstimatedSalary <= 150000 then 'High Salary'
		else 'Very High Salary'
		end
		as SalaryCategory,
	count(*) as TotalCustomers
from Churn_Modelling
group by
	case
		when EstimatedSalary <= 50000 then 'Low Salary'
		when EstimatedSalary <= 100000 then 'Medium Salary'
		when EstimatedSalary <= 150000 then 'High Salary'
		else 'Very High Salary'
		end
order by TotalCustomers desc;
/*
Result:
	|SalaryCayegory  |TotalCustomers|
	|High Salary     |2555			| 
	|Medium Salary   |2537			|
	|Very High Salary|2455			|
	|Low Salary		 |2453			|
*/

--What is the churn rate for each Salary Category?
select
	case
		when EstimatedSalary <= 50000 then 'Low Salary'
		when EstimatedSalary <= 100000 then 'Medium Salary'
		when EstimatedSalary <= 150000 then 'High Salary'
		else 'Very High Salary'
		end
		as SalaryCategory,
count(*) as TotalCustomers,
sum(
	case
		when Exited = 1 then 1 else 0 end ) as ExitedCustomers,
cast(
	sum(
		case
			when Exited = 1 then 1 else 0 end)*100.0/
			count(*) as decimal (5,2)
			) as ChurnRate
from Churn_Modelling
group by 
	case
		when EstimatedSalary <= 50000 then 'Low Salary'
		when EstimatedSalary <= 100000 then 'Medium Salary'
		when EstimatedSalary <= 150000 then 'High Salary'
		else 'Very High Salary'
		end
order by ChurnRate desc;
/*
Result:
	|SalaryCayegory  |TotalCustomers|ExitedCustomers|ChurnRate|
	|Very High Salary|2455			|527			|21.47	  |
	|High Salary     |2555			|517			|20.23	  |
	|Low Salary		 |2453			|489			|19.93	  |
	|Medium Salary   |2537			|504			|19.87	  |
*/

--Which country has the highest churn rate?
select 
	Geography,
	count(*) as TotalCustomer,
	sum(
		case
			when Exited = 1 then 1 else 0 
		end) as ExitedCustomer,
	cast(
		sum(
			case
				when Exited = 1 then 1 else 0 
			end)*100.0/
				count(*) as decimal(5,2)
		) as ChurnRate
from Churn_Modelling
group by Geography
order by ChurnRate desc;
/*
Result:
	|Geography|TotalCustomer|ExitedCustomer|ChurnRate|
	|Germany  |2509			|814		   |32.44	 |
	|Spain	  |2477			|413		   |16.67	 |
	|France	  |5014			|810		   |16.15	 |
*/

--Which gender has the highest churn rate in each country?
select 
	Geography,
	Gender,
	count(*) as TotalCustomer,
		sum(
			case
				when Exited = 1 then 1 else 0 
			end) as ExitedCustomer,
	cast(
		sum(
			case
				when Exited = 1 then 1 else 0 
			end)*100.0/
			count(*) as decimal (5,2)
			) as ChurnRate
from Churn_Modelling
group by Geography, Gender;
/*
Result:
	|Geography|Gender|TotalCustomer|ExitedCustomer|ChurnRate|
	|Germany  |Male  |1316		   |366		      |27.81	|
	|Germany  |Female|1193		   |448		      |37.55	|
	|Spain	  |Male  |1388	       |182		      |13.11	|
	|Spain	  |Female|1089    	   |231		      |21.21	|
	|France	  |Male  |2753		   |350		      |12.71	|
	|France	  |Female|2261		   |460		      |20.34	|
*/

--Which Age Group has the highest churn rate in each country?
select
	Geography,
	case 
		when Age<=30 then 'young adult'
		when Age<=40 then 'adult'
		when Age<=50 then 'middle aged'
		when Age<=60 then 'senior adult'
		else 'senior citizen'
	end as AgeGroup,
	count(*) as TotalCustomer,
	sum(
		case
			when Exited = 1 then 1 else 0 
		end) as ExitedCustomer,
	cast(
		sum(
			case 
				when exited = 1 then 1 else 0
			end)*100.0/
			count(*) as decimal (5,2)
		) as ChurnRate
from Churn_Modelling
group by
	Geography,
	case 
		when Age<=30 then 'young adult'
		when Age<=40 then 'adult'
		when Age<=50 then 'middle aged'
		when Age<=60 then 'senior adult'
		else 'senior citizen'
	end
order by Geography, ChurnRate desc;
/*
Result:
	|Geography |Age Group    | Churn Rate |
	| France    | Senior Adult |        ... |
	| France    | Middle Aged  |        ... |
	| France    | Adult        |        ... |
	| France    | Young Adult  |        ... |
	| Germany   | Senior Adult |        ... |
	| Germany   | Middle Aged  |        ... |
	| Spain     | Senior Adult |        ... |
*/

--Which Active Member status (Active/Inactive) has the highest churn rate in each country?
select
	Geography,
	case 
		when IsActiveMember = 1 then 'Active Member'
		else 'Inactive Member'
	end as MembersStatus,
	count(*) as TotalCustomer,
	sum(
		case
			when Exited = 1 then  1 else 0 
			end) as ExitedCustomer,
	cast(
		sum(
			case
				when Exited = 1 then 1 else 0
				end)*100.0/
				count(*) as decimal(5,2)
				) as ChurnRate
from Churn_Modelling
group by 
	Geography,
	case 
		when IsActiveMember = 1 then 'Active Member'
		else 'Inactive Member'
		end
order by Geography, ChurnRate desc;
/*
Result is too long to write her so self excute here
*/

--Which Number of Products has the highest churn rate in each country?
select 
	Geography,
	NumOfProducts,
	count(*) as TotalCustomers,
	sum(
		case
			when Exited = 1 then 1 else 0
			end) as ExitedCustomers,
	CAST(
		sum(
			case
				when Exited = 1 then 1 else 0
				end)*100.0/
				count(*) as decimal(5,2)
				) as ChurnRate
from Churn_Modelling
Group by 
	Geography,
	NumOfProducts
order by NumOfProducts, ChurnRate desc;

--Which Credit Score Category has the highest churn rate in each country?
select
	Geography,
	case 
		when CreditScore <=500 then 'poor'
		when CreditScore <=650 then 'fair'
		when CreditScore <=750 then 'good'
		else 'excellent'
	end as CreditCategory,
	count(*) as TotalCustomers,
	sum(
		case
			when Exited = 1 then 1 else 0
		end) as ExitedCustomers,
	cast(
		sum(
			case
				when Exited = 1 then 1 else 0
			end)*100.0/
			count(*) as decimal(5,2)
			) as ChurnRate
from Churn_Modelling
group by
	Geography,
	case 
		when CreditScore <=500 then 'poor'
		when CreditScore <=650 then 'fair'
		when CreditScore <=750 then 'good'
		else 'excellent'
	end
order by 
	Geography,
	ChurnRate desc;

--Which Balance Category has the highest churn rate in each country?
select
	Geography,
	case 
		when Balance<=0 then 'Zero Balance'
		when Balance<=50000 then 'Low Balance'
		when Balance<=100000 then 'Medium Balance'
		else 'High Balance'
	end
	as 'Balance Category',
	count(*) as TotalCustomers,
	sum(
		case
			when Exited = 1 then 1 else 0
		end) as ExitedCustomers,
	cast(
		sum(
			case
				when Exited = 1 then 1 else 0
			end)*100.0/
			count(*) as decimal(5,2)
			) as ChurnRate
from Churn_Modelling
group by
	Geography,
	case 
		when Balance<=0 then 'Zero Balance'
		when Balance<=50000 then 'Low Balance'
		when Balance<=100000 then 'Medium Balance'
		else 'High Balance'
	end
order by 
	Geography,
	ChurnRate desc;

--Which Salary Category has the highest churn rate in each country?
select
	Geography,
	case
		when EstimatedSalary <= 50000 then 'Low Salary'
		when EstimatedSalary <= 100000 then 'Medium Salary'
		when EstimatedSalary <= 150000 then 'High Salary'
		else 'Very High Salary'
		end
		as SalaryCategory,
	count(*) as TotalCustomers,
	sum(
		case
			when Exited = 1 then 1 else 0
		end) as ExitedCustomers,
	cast(
		sum(
			case
				when Exited = 1 then 1 else 0
			end)*100.0/
			count(*) as decimal(5,2)
			) as ChurnRate
from Churn_Modelling
group by
	Geography,
	case
		when EstimatedSalary <= 50000 then 'Low Salary'
		when EstimatedSalary <= 100000 then 'Medium Salary'
		when EstimatedSalary <= 150000 then 'High Salary'
		else 'Very High Salary'
		end
order by 
	Geography,
	ChurnRate desc;

--Who are the Top 10 customers with the highest account balance?
select top 10
	CustomerID,
	Surname,
	Geography,
	Balance
from Churn_Modelling
order by Balance desc;

--Who are the Top 10 customers with the highest estimated salary?
select top 10
	CustomerID,
	Surname,
	Geography,
	EstimatedSalary
from Churn_Modelling
order by EstimatedSalary desc;

--Who are the Top 10 customers with the highest Credit Score?
select top 10
	CustomerID,
	Surname,
	Geography,
	CreditScore
from Churn_Modelling
order by CreditScore desc;

--Create an Executive Summary of the Bank
select 
	count(*) as TotalCustomers,
	sum(
		case
			when Exited = 1 then 1 else 0
		end) as ExitedCustomers,
	sum(
		case
			when Exited = 0 then 1 else 0 
		end) as StayedCustomers,
	cast(
		sum(
			case
				when Exited = 1 then 1 else 0 
			end)*100.0/
			count(*) as decimal (5,2)
			) as ChurnRate,
	round(
		avg(CreditScore), 2
		) as AvgCreditScore,
	round(
		avg(Balance),2
		) as AvgBalance,
	round(
		avg(EstimatedSalary), 2
		) as AvgEstimatedSalary
from Churn_Modelling;

--Create a dashboard-ready dataset by adding business-friendly calculated columns.
select 
	CustomerID,
	Surname,
	Geography,
	Gender,
	Age,
	case 
		when Age<=30 then 'young adult'
		when Age<=40 then 'adult'
		when Age<=50 then 'middle aged'
		when Age<=60 then 'senior adult'
		else 'senior citizen'
	end as 'Age Group',
	Balance,
	case 
		when Balance<=0 then 'Zero Balance'
		when Balance<=50000 then 'Low Balance'
		when Balance<=100000 then 'Medium Balance'
		else 'High Balance'
	end
	as 'Balance Category',
	CreditScore,
	case 
		when CreditScore <=500 then 'poor'
		when CreditScore <=650 then 'fair'
		when CreditScore <=750 then 'good'
		else 'excellent'
	end as 'Credit Category',
	EstimatedSalary,
	case
		when EstimatedSalary <= 50000 then 'Low Salary'
		when EstimatedSalary <= 100000 then 'Medium Salary'
		when EstimatedSalary <= 150000 then 'High Salary'
		else 'Very High Salary'
		end
		as 'Salary Category',
	Tenure,
	NumOfProducts,
	HasCrCard,
	case
		when IsActiveMember = 1 then 'Active Member'
		else 'Inactive Member'
		end as 'Member Status',
	case
		when Exited = 1 then 'Exited'
		else 'Stayed'
		end as 'Churn Status'
from Churn_Modelling;
