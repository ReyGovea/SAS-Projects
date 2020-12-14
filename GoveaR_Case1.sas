/* Rey Govea Case Study 1*/
/*I certify that the SAS code given is my original and exclusive work*/

/*1(a) -- using proc import and proc print w/ 'obs'option to get data from XLSX file and print 1st 20 obs.*/
PROC IMPORT DATAFILE="/home/rag170/STA3064_SAS Modeling/Homework/Projects/AirFoil.xlsx"
		    OUT=Air
		    DBMS=XLSX
		    REPLACE;
RUN;


PROC PRINT DATA=Air (obs=20); RUN;

/*1(b) -- plotting relationship between response(sound) and all other variables; Create a scatterplot
				 matrix showing relationship between all variables*/

proc sgscatter data=air;
	plot sound* (Freq Angle Length Velocity Displace);
run; 

proc corr data=air plots=matrix; run;

/*2(a-c) -- Fit a linear regression, look at parameter est. for equation, and look at residuals to validate assumptions*/ 
proc reg data=air;
	model sound= displace;
run;

/*2(d) -- evaluating what transformation is necessary and performing the transformation*/ 
proc transreg data=air;
	model boxcox (sound)= identity(displace);
run; 

data Air2;
	set Air;
	Y2= sound**3;
run;

proc reg data=Air2;
	model Y2= displace;
run; 

/*2(e) -- find a 95% confidence interval*/ 
proc reg data=air;
	model sound=displace/clb;
run; 

/*2(f) -- use bootstrap method to find 95% confidence interval*/ 
proc surveyselect data=air out=Boot_Air
	seed=2000 samprate=1 
	method=urs outhits rep=5000; /*1) SAS looks at the sample peaks as a populaiton to collect a sample of
									2) out=boot -- creates another dataset with the samples of the sample 
									3) seed = -1 -- creates a completely random set 
									4) sampreate =1 -- places a 100% sampling rate 
									5) method= urs -- sample with replacement 
									6) outhits -- full data set displayed 
									7) rep 1000 -- 1000 psuedo samples*/
run;

		/*proc univeriate is creating bounds for the 95% confidence interval*/ 
proc univariate data=Boot_air noprint;
	var displace;
	output out=BootCI pctlpts= 2.5 97.5 pctlpre= Conf_Limit_;
run;

proc print data=bootCI;
run;
	
/*2(g) -- use proc reg to look at anova table*/ 
proc reg data=air;
	model sound= displace;
run; 

/*2(h) -- create a value for displace of 0.028 to examine a 95% CI for Ind. and Mean.*/ 
data New_air;
input displace;
datalines;
.028
;
run;

data Air2;
	set new_air air;
run;

proc reg data=Air2;
	model Sound= Displace/ clm cli;
run; 

/*3(a) -- look to see what variables have greatest multi-colinearity*/ 
proc reg data=air;  
	model sound = Freq Angle Length Velocity Displace/ VIF;
Run; 

/*3(b) -- forward selection used to choose best fit variables and remove uninfluential ones*/
proc reg data=air;
	model sound = Freq Angle Length Velocity Displace/ selection = forward;
run;

/*3(c) -- nested F-test; Fail to reject the null that beta of angle and velocity =0 */
proc reg data= air;
	model sound = Freq Angle Length Velocity Displace;
	test Angle=0, Velocity=0;  
run; 

/*3(d) -- look at Cook's D to find anomoly in testing 3/4 through data collection that created an outlier*/ 
proc reg data=air;  
	model sound = Freq Angle Length Velocity Displace;
Run; 

/*3(e) -- Using the information from 3d remove observation 69 to see how it affects model*/
data Null_air;
	set air;
	if freq ne 20000;
run;

proc reg data=null_air;
	model sound = Freq Angle Length Velocity Displace;
Run; 




