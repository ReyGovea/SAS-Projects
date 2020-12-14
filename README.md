# SAS-Projects

```
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


```



