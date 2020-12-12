libname HW10 '/home/rag170/my_courses/jhshows0/STA5066';

proc contents data= hw10.orders;run;
proc print data=hw10.orders (obs=100);run;

/* Exercise 1: Using the freq procedure to display the number of distinct levels  */
title 'Unique Customers and Salespersons for Retail Sales'; /*Title assignment*/
proc freq data= hw10.orders nlevels; /*using nlevels to show the sum of all the levels*/
	where order_type = 1; /*subsetting the data to only show the levels by retail sales*/
	tables Customer_ID Employee_ID/ noprint; /*suppressing the observations that arent the total levels*/
run;

title;

title 'Unique Customers for Catelog and Internet'; /*Assigning a title*/
proc freq data= hw10.orders nlevels; /*using option to sum the total levels*/
	where order_type ne 1; /*subsetting to catalog and internet orders*/
	tables customer_ID/noprint; /*suppressing the observations that arent the total levels*/
run;

title;


/* Excercise 2: Using proc format to create a user defined format  */
proc format; 
	value ordertypes 1=’Retail’ 2=’Catalog’ 3=’Internet’; 
run; 

/* 		-> producing the number of orders in each year		 */
proc freq data=hw10.orders;
	tables Order_Date;
	format Order_Date YEAR4.; /*using year4. format to join all observations in a year together*/
run;

/* 		->find the number of orders for each order type */
proc freq data=hw10.orders; 
	tables Order_Type/nocum nopercent; /*eliminating the cumfreq and percenteges*/
	format Order_Type ordertypes.; /*using the previous formatting to assign the user def. format*/
run; 

/* 		-> find the number of orders for each combination of year by order type */
proc freq data=hw10.orders; 
	tables Order_Date*Order_Type/nopercent; /*eliminating percentages and creating a two way table*/ 
	format Order_Date YEAR4.
			Order_Type ordertypes.; /*applying the formatting*/
run;


/* Excercise 3: creating an output data set  */

/* 		-> creating a table measuring the count of productID and then outputting a data set that holds the freq counts based on prod. ID */
proc freq data= hw10.order_fact;
	tables product_ID/ OUT=freqcount;
run;

/* 		-> merging the outputted data set from above with Product_List to obtain the product_name for each product ID code */
data new;
	merge hw10.product_list
			freqcount;
run;

/* 		-> sorting by descending to get the highest ordered products to lowest ordered products */
proc sort data=new;
	by descending Count;
run;

/* 		-> printing the top ten ordered products */
proc print data=new (obs=10); run;


/* Exercise 4: Creating a summary report using proc means */

/* 		->Assigning a user defined format to categorically name the numerical assignment for order types */
proc format; 
	value ordertypes 1=’Retail’ 2=’Catalog’ 3=’Internet’; 
run; 

/* 		-> Looking for the sum of the variable total_retail_price that is organized by year and order type */
title 'Revenue (in U.S. Dollary) Earned from All Orders';
proc means data= hw10.order_fact sum; /*specifying to only provide the sum stat*/
	var Total_Retail_Price; /*specifying the variable*/
	class Order_Date Order_Type; /*Assigning two class' s.t. it will sum the order type by date*/
	format Order_Type ordertypes.
			Order_Date YEAR4.;/*Applying the user format and year format*/
run;

title;


/* Exercise 5: Analyzing missing numeric values with proc means */

/* 		-> wanting to classify the data by gender and then find the number of missing and nonmissing obs for each variable that is contained in the set of gender */
title 'Nuber of Missing and Non-Missing Date Values';
proc means data= hw10.staff nmiss n NONOBS ; /*wanting to use the number missing and number observed statistics and drop the column specifying the number of observations*/
	var Birth_Date Emp_Hire_Date Emp_Term_Date;  /*specifying the variables*/
	class Gender; /*Assigning a class to which the variables will be applied to*/
run;

title;


/* Exercise 6: Creating and output data set with proc means */

/* 		-> Using proc means to print the sum of total retail price by each individual product ID */
proc means data= hw10.order_fact sum;
	var total_retail_price; 
	class Product_ID; 
	output out= Total; /*outputting a new data set that holds the sum of the total retail price*/
run;

/* 		-> merging the data from the previous proc means with the product list to obtain the product name value for each product ID */
data merged;
	merge hw10.product_List
			Total;
run;

/* 		-> sorting the data by descending to place the highest revenues on top */
proc sort data=merged;
	by descending Total_Retail_Price;
run;

/* 		-> printing the top ten products with the most revenue */
proc print data=merged (obs=10); run;


/* Exercise 7: Proc Freq Nhanes3 */

/* 		-> creating a new data set that only holds specified variables from origional data set */
data AnalysisTmp (keep= seqn dmaracer dmarethn dmaethnr hssex hsageir);	
	set hw10.analysis;
run;
	
/* 		->creating one way tables for three variables with only the frequency showing as statistics */
proc freq data=analysistmp ;
	tables dmaracer dmarethn hssex/ nocum nopercent;
run;

/* 		-> repeating the above one way tables but only analyzing by people that are females and less than 50 yrs old */
proc freq data=analysistmp ;
	where hssex=2 AND hsageir<50 ; /*hssex = 2 is female -- subsetting the data to create the freq table*/
	tables dmaracer dmarethn hssex/ nocum nopercent;
run;

/* 		-> formatting age into easily digestible groups  and then creating three two way tables of age*(Race, Race/Ethnicity, sex) */
proc format; 
	value agef low-<45= "<45"
		45-59= "45-59"
		60-high= "60+";
Run;

proc freq data=analysistmp;
	tables hsageir*(dmaracer dmarethn hssex);/*creates three different two way tables -- multiply to get combinations*/
	format hsageir agef.; /*applying the age format for easier grouping*/
run;


/* Excercise 8: Proc Univariate, heart data set analyzing cholesterol variable */

/* 		-> creating a histogram with a overlayed theoretical normal distribution over the data  */
/* 		-> creating a summary box with position (pos) in the north east corner and containing n, mean, and standard deviation all with one decimal place */
proc Univariate data= sashelp.heart;
	histogram cholesterol/ normal;
	inset n mean(5.1) std='Std Dev' (4.1) /*assigning length to the stats of one decimal place*/
             / pos = ne  header = 'Summary Statistics';
run;

/* 		-> generating a qqplot to measure how well the data for cholesterol fits a normal distribution */
/* 		-> creating another summary statistics box that is the same as the previous but this one is placed in the north region of the graph */
proc univariate data=sashelp.heart;
	qqplot cholesterol;
	inset n mean(5.1) std='Std Dev' (4.1) 
             / pos = n  header = 'Summary Statistics';
run;





