**** Exercise 1;

* input data;
data cars;
input pair before after;
cards;
1 2.37 2.51
2 3.17 2.65
3 3.07 2.60
4 2.73 2.40
5 3.49 2.31
6 4.35 2.28
7 3.65 0.94
8 3.97 2.21
9 3.21 3.29
10 4.46 1.92
11 3.81 3.38
12 4.55 2.43
13 4.51 1.83 
14 3.03 2.63
15 4.47 2.31
16 3.44 1.85
17 3.52 2.92
18 3.05 2.26
19 3.66 3.11
20 3.81 1.90
21 3.13 2.50
22 3.43 3.18
23 3.26 3.24
24 2.85 2.16
;
run;

* convert to flat table;
data carsflat; set cars;
length treatment $10; * this just gives the length of the variable treatment, use dollar sign b/c treatment is a char variable;
treatment = "before"; Y = before; output;
treatment = "after"; Y = after; output;
keep Y treatment pair;
run; 


* alternate way to convert to flat table;
/*
proc tranpose data=[data] out=[OUTPUT DS];
	by [ID];
run;

*/

* run CRBD model: Y = treatment + block(pair);
* output residuals;
proc glm data=carsflat;
class treatment pair;
model Y = treatment pair;
output out=residuals r=res;
run;
quit;

* normality check on residuals;
proc univariate normal plot data=residuals;
	var res;
run;
quit; * output shows we reject normality but has different shapiro p-value than the difference normality check


* add column var difference;
data cars; set cars;
difference = before-after;
run;

* test normality of difference;
proc univariate normal plot data=cars;
var difference;
run;
quit;

* one sample ttest on differences. has same t-test stat as paired t-test;
proc ttest data=cars;
var difference;
run;

* three F-tests are offered: model, treatment, pair
	If we are curious about the treatment effect we look at the treatment F-test stat
	If we are curious about the pair effect we look at the pair F-test stat
	The model F-test stat describes how the model explains the variation;

* run paired ttest on cars, needs non-flat table;
proc ttest data=cars;
paired before*after;
run;
quit;

* paired t deg of freedom = F error deg of freedom
	output shows a t-test stat = 5.77 AND 5.77^2=33.29 ~ F-test stat --> F=t^2;

* since the above output of the residuals normality check shows non-normality, we have to do a non-parametric test usign Rank;

* run Friedman test, needs flat table;
proc freq data=carsflat;
table pair*treatment*Y / /*the backslash is necessary sytnax*/
cmh2 scores=RANK noprint;
run;

***Exercise 2;

* Model should be --> Y(=mpg) = factor(=blend) + block(=driver) + block(=model);
* input data to match the Latin square design in the question -- already stacked;
data blend;
input driver$ model$ blend$ mpg;
cards;
1 1 A 15.5
1 2 B 33.8
1 3 C 13.7
1 4 D 29.2
2 1 B 16.3
2 2 C 26.4
2 3 D 19.1
2 4 A 22.5
3 1 C 10.5
3 2 D 31.5
3 3 A 17.5
3 4 B 30.1
4 1 D 14.0
4 2 A 34.5
4 3 B 19.7
4 4 C 21.6
;
run;

* run ANOVA procedure and output residuals into data set bresids;
proc glm data=blend;
class blend; *model driver; 
model mpg = blend; * model driver;
output out=bresids r=res;
means blend / hovtest=levene; * to run levene test we needed to fake the data into a one-way ANOVA by leaving only the treatment(blend), levene can only be done on one-way;
run;
quit;

* test normality on residuals;
proc univariate normal plot data=bresids;
var res;
run;
quit;

* normality is good;
* glm procedure shows 
	the driver does not have sig effect,
	the model does have sig effect,
	the blend does have sig effect;
	
