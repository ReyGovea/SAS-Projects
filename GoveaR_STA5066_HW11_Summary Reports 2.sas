libname HW11 '/home/rag170/my_shared_file_links/jhshows0/STA5066' ;

/* Question 1: Specifying Multiple Titles */

Title1 'Orion Star Sales Analysis'; /*assigning title for both reports*/
proc means data=orion.order_fact;
	title2 'Catalog Sales Only'; /*assigning a second title for the first report */
	footnote "Based on the previous day's posted data"; /*applying a footnote to only the first report*/
   where Order_Type=2;
   var Total_Retail_Price;
run;
Footnote; /*resetting the footnote to null*/

proc means data=orion.order_fact;
   title2 "Internet Sales Only"; /*replacing the subtitle from the first report*/
   where Order_Type=3;
   var Total_Retail_Price;
run;

title;


/* Question 2: Inserting Dates and Times into Titles*/

%let currentdate=%sysfunc(today(),weekdate.); /*user defined macrovariables used to input the date and time of the report*/
%let currenttime=%sysfunc(time(),timeampm.);
title "Sales Report as of &currenttime on &currentdate";
proc means data=orion.order_fact;
   var Total_Retail_Price;
run;

title;

/* Question 3: Overriding Existing Labels and Formats */

proc print data=orion.customer label; /*using the label in proc print step ensures that the label replacement will happen*/
   where Country='TR';
   title 'Customers from Turkey';
   var Customer_ID Customer_FirstName Customer_LastName
       Birth_Date;
   label Customer_ID = 'Customer ID'
   		 Customer_FirstName = 'First Name'
   		 Customer_LastName = 'Last Name'
   		 Birth_Date = 'Birth Year'; /*changing the titles of the variables with the label statement temporarily*/
   format Birth_Date year4.; /*assinging a year format to the sas year assignment*/
run;	

/* Question 4: Creating User Defined Formats*/

data Q1Birthdays;
   set orion.employee_payroll;
   BirthMonth=month(Birth_Date);
   if BirthMonth le 3;
run;

proc format; /*defining the user defined formats that will be used in the proc freq*/
	value $gender	F = 'Female'
					M = 'Male';
	Value moname	1 = 'January'
					2 = 'February'
					3 = 'March';
run;

proc freq data=Q1Birthdays;
   tables BirthMonth Employee_Gender;
   format Employee_Gender $gender.
   		  BirthMonth moname.; /*assigning the previously def. formats to the variables*/
   title 'Employees with Birthdays in Q1';
run;

/* Question 5: Defining Ranges in User Defined Formats */

proc format; /*defining the user defined formats that will be used in the proc freq*/
	value $gender	F = 'Female'
					M = 'Male'
					Other ='Invalid Code' ;
	Value SalRange	20000-<100000 = 'Below $100,000'
					100000-500000 = '$100,000 or more'
					Other = 'Invalid Salary'
					. = 'Missing Salary'; /*assigning a range to label numeric salary groups and assigning values to missing and invalid inputs*/
run;

proc print data=orion.nonsales (obs=10);
   var Employee_ID Job_Title Salary Gender;
   format Gender $gender.
   		  Salary SalRange.; /*applying the user def. format*/
   title1 'Distribution of Salary and Gender Values';
   title2 'for Non-Sales Employees';
run;

/* Question 6: Subsetting the Grouping Observations */

proc sort data=orion.order_fact OUT= ORDER; /*sorting the data by order type*/
	BY Order_Type;
run;

proc means data=ORDER;
   var Total_Retail_Price;
   where Order_Type = 2 OR Order_Type = 3; /*Subsetting the data*/
   By Order_Type; /*outputting order type 2 and 3 separately*/
   title 'Orion Star Sales Summary';
run;	

/* Question 7: Subsetting and Grouping by Multiple Variables */

proc sort data=HW11.order_fact OUT= Fact;
	BY Order_Type descending Order_Date;
run;

data fact;
	set fact;
	Delivery_Time = Delivery_Date - Order_Date;
run;
	
	
proc print data=Fact;
   var Order_Type Order_ID Order_Date Delivery_Date ;
   BY Order_Type;
   Where Order_Date ge '01JAN2005'd AND Order_Date le '30APR2005'd
    AND Delivery_Time = 2;
   title1 'Orion Star Sales Details';
   title2 'Filters have been applied to the data';
run;
title;

/* Question 8: Creating a Simple Tabular Report with PROC TABULATE */

proc tabulate data=orion.customer_dim;
	title 'Ages of Customers by Group and Gender';
	class Customer_Group Customer_Gender; /*Assigning the columns to classify the analysis on the variable customer age*/
	var Customer_Age;
	table Customer_Group*Customer_Gender all,
			Customer_Age*(n Mean); /*assigning the (class*Class,variable) and then specifying the statistics to analyze the data by*/
run;












