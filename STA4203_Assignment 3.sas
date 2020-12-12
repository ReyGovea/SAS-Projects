FILENAME spiders '/home/rag170/my_courses/jhshows0/Data Sets/spider.txt';
Data spiders;
infile spiders;
input spiders x1-x4;
run; 
/*Question1a*/
proc reg data=spiders;
model spiders= x1 x2 x4/ss1;
two: TEST x2=0;
model spiders=x1 x4;
run;
/*Question 1b*/
proc reg data=spiders;
model spiders= x1 x2 x3 x4/ss1;
two: TEST x2=0;
model spiders=x1 x3 x4;
run;
/*Question 1c*/
proc reg data=spiders;
model spiders= x1  x3 x4/ss1;
two: TEST x3=0, x4=0;
model spiders=x1;
run;

/*Question 2*/
FILENAME Prostate '/home/rag170/my_courses/jhshows0/Data Sets/prostate.txt';

DATA prostate; 
INFILE prostate;
INPUT x1-x9 y;
RUN;

PROC REG DATA=Prostate;
MODEL y=x2-x9/SELECTION=ADJRSQ AIC BIC CP;
RUN;

PROC REG DATA=prostate;
MODEL y=x2-x9/SELECTION=FORWARD;
RUN;

PROC REG DATA=prostate;
MODEL y=x2-x9/SELECTION=BACKWARD;
RUN;

PROC REG DATA=prostate;
MODEL y=x2-x9/SELECTION=STEPWISE;
RUN;

/*determine which of x6,x7,x8 causes largest decrease in SSE
when x1-x5 are in the model*/
proc reg data=sports;
model y=x1-x5/ss2;
model y=x1-x6/ss2;
model y=x1-x5 x7/ss2;
model y=x1-x5 x8/ss2;
run;

