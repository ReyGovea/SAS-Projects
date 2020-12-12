/*Rey Govea Assignment3*/
/*I certify that the SAS code given is my origional and exclusive Work*/
data SNL; /*Q1a*/
Input 
	@1 Name $18.
	@25 Appearances 2.
	@41 First date9.
	@64 Fifth mmddyy10.; /*formated style of input used for specifying the length and date style of each variable*/
Format First fifth mmddyy8.; /*the format statement makes the different dating methods both be organized by month day and two didget year*/
Datalines;
Buck Henry              10              17-Jan-76              11/19/1977
Steve Martin            15              23-Oct-76              4/22/1978
Elliott Gould            6              10-Jan-76              2/16/1980
Chevy Chase              8              18-Feb-78              12/6/1986
Candice Bergen           5               8-Nov-75              5/19/1990
Tom Hanks                9              14-Dec-85              12/8/1990
Danny DeVito             6              15-May-82              1/9/1993
John Goodman            13               2-Dec-89              5/7/1994
Alec Baldwin            17              21-Apr-90              12/10/1994
Bill Murray              5               7-Mar-81              2/20/1999
Christopher Walken       7              20-Jan-90              5/19/2001
Drew Barrymore           6              20-Nov-82              2/3/2007
Justin Timberlake        5              11-Oct-03              3/9/2013
Ben Affleck              5              19-Feb-00              5/18/2013
Tina Fey                 6              23-Feb-08              12/19/2015
Scarlett Johansson       5              14-Jan-06              3/11/2017
Melissa McCarthy         5               1-Oct-11              5/13/2017
Dwayne Johnson           5              18-Mar-00              5/20/2017
Jonah Hill               5              15-Mar-08              11/3/2018
; Run;

Proc Print data=SNL; Run;

Proc sort data=SNL out=Q1b;
	by descending appearances; Run; /*sorting statement makes obs be organized by largest to smallest appearences*/

Proc Print data=Q1b; 
	format fifth worddate11.; /*format statement and worddate input make month of fifth Show names by month name*/
	var fifth Name ; Run; /*var statement make output only show the two variables*/
	
data Q1c;
	Set SNL;
	 difference= (fifth-first)/365.25;
proc print data=Q1c; Run;
/*------------------------------------------------------------*/
data Batteries;
input Battery_Brand $ standby_hrs @@; /*the @@ tells SAS to read multiple observations per line*/
datalines;
A  44  A  54  A  54
A  64  A  64  A  44
A  34  A  24  A  24
A  44  A  34  A  54
A  34  A  34  A  54
A  54  A  54  B  66
B  66  B  51  B  36
B  66  B  81  B  36
B  81  B  66  B  36
B  96  B  66  B  51
B  96  B  66  B  51
B  36  C  44  C  37
C  51  C  44  C  51
C  51  C  44  C  51
C  37  C  37  C  30
C  37  C  30  C  65
C  51  C  37  C  58
D  43  D  45  D  55
D  36  D  45  D  33
D  44  D  36  D  45
D  37  D  34  D  43
D  43  D  63  D  47
D  45  D  35    
; Run;

Proc Print data=Batteries (firstobs=15 obs=40); Run; /*firstobs and obs output data to only include obs 15-40*/

proc print data=batteries;Run; 

Proc sgplot data=batteries;
	vbar Battery_Brand /response=Standby_Hrs stat=mean  
	          fillattrs=(color=Steel)
	          dataskin=Gloss
	          barwidth=.6; Run; /*creates boxplot with brand on x axis and hrs standby as response var.
	          						fillattrs specified to make bars the steel color and dataskin customizes the appearance of bars
	          						barwidth adjstment specifies the width of the box's*/

Proc boxplot data=Batteries; 
	plot standby_hrs*Battery_Brand / boxstyle=schematic; 		/*proc boxplot creates a boxplot with the second like both specifying th response
																	and predictor variable and specifying to place the boxplot in a schematic format
																	the title statement customizes the header*/
	title 'Distrobution of Battery Brands by Standby Hours';
	ods text= 'Q2d: I would choose battery brand B because it has the highest standy hours and the largest mean and median standyby hour amount';
	Run;
 
/*------------------------------------------------------------*/
Data Seasonal_Airlines; /*Q3a- printed the data set*/
input season $ Delta Icelandair British_Airways;
datalines;
Summer   1675     1473     1370
Summer   1435     1206     1252
Summer   1295     1273     1580
Summer   1355     1109     2575
Summer   1586     1078     2275
Fall      969     1050     1287
Fall     1128      970     1460
Fall     1027     1017     1047
Fall     1157      997     1274
Fall     1230      991     1195
; Run;

proc print data=seasonal_Airlines; Run;	
	
Proc sgplot data=seasonal_airlines; /*Q3b- superimposing line graphs*/
	vline season/response=delta stat=mean /*specifies response and dependent variable as well as measure of data*/
				lineattrs=(color=Red)
				markers markerattrs=(color=Blue symbol=Squarefilled); /*this line specifies the symbol of the mean data point and if it is filled along with its color*/
	vline season/response=Icelandair stat=mean 
				lineattrs=(color=orange pattern=dot) /*specifies lines color and pattern*/
				markers markerattrs=(color=brown symbol=Triangle); 
	vline season/response=British_Airways stat=mean 
				lineattrs=(color=khaki  pattern=dash)
				markers markerattrs=(color=silver symbol=diamondfilled);
				ods text='Q3c: The data shows that all airline prices increase from fall to summer with british 
								airways having the largest mean cost and increase and iceland air having the lowest'; Run;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
