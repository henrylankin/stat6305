**** inputing data;

* regular way;
data _data set name_;
	input -column names-; * name should be followed with a '$' 
							if character data is expected;
	cards;
--data--
; * above should have one element for each data column; 
run;

** example;
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
	length treatment $10; * this just gives the length of the variable treatment, 
							use '$' b/c treatment is a char variable;
	treatment = "before"; Y = before; output;
	treatment = "after"; Y = after; output;
	keep Y treatment pair; * pair is just the index from the input of data above;
run; 

* alternate way to convert to flat table;
/*
proc tranpose data=[data] out=[OUTPUT DS];
	by [ID];
run;

*/

*** running tests and checking assumptions;

** simple CRD model with no interactions;
/*
ANOVA Model: y(ij) = mu + tau(i) + error(ij)
GLM Model: y = beta(0) + beta(1)x(1) + beta(2)x(2) + .... + beta(t-1)x(t-1)
	beta_hat(0) = intercept
	beta_hat(i) = parameter estimate of treatment i
	beta_hat(t) = always set to 0 by SAS
	x(i) = 1 for treatment i; 0, otherwise 
		*this model uses t-1 "dummy" variables
Hypotheses:
	H0: tau(1)=tau(2)=...=tau(N)=0
	Ha: at least one tau(i) != 0
	... same hypotheses for other factors as well
*/
proc glm data=_data set name_;
	class _any categorical factors_;
	model _Y_ = --factors--; * put in '/ solution' to output 
								parameter estimates;
	means _factor of interest_ / hovtest=levene; *runs levene equal variances test
													only allowed for one-way anova;
	output out=_data set name with residuals_ r=_residuals var name_ p =_fitted values_;
							* this outputs the a data set with the 
								residual values under _residuals var name_
								and the fitted values under _fitted values_;d
run;
quit; * should always put quit at the end of proc glm;

** example;
data blend_1;
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
	class blend;  
	model mpg = blend / solution; * '/ solution'  outputs parameter estimates;
	output out=bresids r=res p=fitted_values; * r=residual values & p=fitted values;
	means blend / hovtest=levene; * run levene test for equal variances;
run;
quit;

* test normality on residuals;
proc univariate normal plot data=bresids;
	var res;
run;
quit;

** CRD/factorial design model with interactions;
/*
ANOVA Model: y(ijk) = mu + tau(i) + beta(j) + tau*beta(ij)+error(ijk)
GLM Model: y = beta(0) + beta(1,1)x(1,1) + .... + beta(1,t-1)x(1,t-1)
				+ beta(2,1)x(2,1) + .... + beta(2,r-1)x(2,r-1)
	beta_hat(0) = intercept
	beta_hat(1,i) = parameter estimate of treatment i=1,...,t-1 for factor 1
	beta_hat(2,j) = parameter estimate of treatment j=1,...,r-1 for factor 2
	beta_hat(12,i,j) = parameter estimate of treatment i,j for interaction
	beta_hat(1,t), beta_hat(2,r), beta_hat(12,t, j) = always set to 0 by SAS
	x(m,i) = 1 for treatment i of factor m=1,2; 0, otherwise 
		*this model uses (t-1)+(r-1)+(t-2)(r-1) "dummy" variables
Hypotheses:
	Factors:
	H0: tau(1)=tau(2)=...=tau(N)=0
	Ha: at least one tau(i) != 0
	... same hypotheses for other factors as well
	Interaction:
	H0: tau*beta(ij) = 0, for all i,j
	Ha: at leasut one tau*beta(ij) != 0
*/

* input data unstacked;
data soil;
	input ph calcium100 calcium200 calcium300;
	cards;
4 5.2 7.4 6.3
4 5.9 7 6.7
4 6.3 7.6 6.1
5 7.1 7.4 7.3
5 7.4 7.3 7.5
5 7.5 7.1 7.2
6 7.6 7.6 7.2
6 7.2 7.5 7.3
6 7.4 7.8 7
7 7.2 7.4 6.8
7 7.5 7 6.6
7 7.2 6.9 6.4
;
run;

*stack only the calcium part of the data;
data soil_flat; set soil;
	calcium = 'calcium100'; diameter = calcium100; output;
	calcium = 'calcium200'; diameter = calcium200; output;
	calcium = 'calcium300'; diameter = calcium300; output;
	keep diameter ph calcium;
run;

* factorial test;
proc glm data=soil_flat;
	class calcium ph;
	model diameter = calcium ph ph*calcium / solution;
	contrast '100,200 vs. 300' calcium 1 1 -2; * contrast statement;
	contrast '100 vs. 200' calcium 1 -1 0;
run;
quit;

** CRBD (block design) & Latin Square Design (special type of block);
/*
ANOVA Model: y(ijk) = mu + tau(i) + block(j) + error(ijk)
GLM Model: y = beta(0) + beta(1)x(1) + beta(2)x(2) + .... + beta(t-1)x(t-1)
	beta_hat(0) = intercept
	beta_hat(i) = parameter estimate of treatment i
	beta_hat(t) = always set to 0 by SAS
	x(i) = 1 for treatment i; 0, otherwise 
		*this model uses t-1 "dummy" variables
	* add in block paramters as needed
Hypotheses:
	H0: tau(1)=tau(2)=...=tau(N)=0
	Ha: at least one tau(i) != 0
	... same hypotheses for other factors as well, no testing necessary for blocks
*/

proc glm data=_data set name_;
	class _any categorical factors and blocks_;
	model _Y_ = --factors-- --blocks--; 
			* looks like CRD with no interactions;
			* put in '/ solution' to output parameter estimates;
	means _factor of interest_ / hovtest=levene; *runs levene equal variances test
													only allowed for one-way anova;
	output out=_data set name with residuals_ r=_residuals var name_ p =_fitted values_;
							* this outputs the a data set with the 
								residual values under _residuals var name_
								and the fitted values under _fitted values_;d
run;
quit; * should always put quit at the end of proc glm;

** example;

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

* run CRBD procedure and output residuals into data set bresids;
* SAS takes it the same as factorial treatment with no interactions;
proc glm data=blend;
class blend model driver; 
model mpg = blend model driver / solution;
output out=bresids r=res;
* means blend / hovtest=levene; 
	* to run levene test we needed to fake the data
		into a one-way ANOVA by leaving only the 
		treatment(blend), levene can only be done
		on one-way;
run;
quit;

** ANCOVA model;
/*
one-way ANCOVA Model: y(ij) = beta(0) + tau(i) + beta(1)x(i,j) + error(ij)
	* add factors, blocks, interactions as necessary
	beta(0) = intercept
	beta(1) = regression coefficient (slope)
	x(i,j) = covariate
Full GLM Model: y = beta(0) + beta(1)x(1) + beta(2)x(2) + .... + beta(t)x(t)
	beta_hat(0) = intercept
	beta_hat(i+1) = parameter estimate of treatment i=1,2,...,t-1
	beta_hat(t+1) = always set to 0 by SAS, representing treatment t
	x(i+1) = 1 for treatment i=1,2,...,t-1; 0, otherwise 
		*this model uses t-1 "dummy" variables
	* add in factor, block, interaction paramters as needed
Reduced model 1 (ANOVA): y = beta(0) + beta(1)x(1) + beta(2)x(2) +...+ beta(t-1)x(t-1)
	beta_hat(0) = intercept
	beta_hat(i) = parameter estimate of treatment i=1,2,...,t-1
	x(i) = 1 for treatment i=1,2,...,t-1; 0, otherwise
Reduced model 2 (regression): y = beta(0) + beta(1)x(j)
	beta_hat(0) = intercept
	beta_hat(1) = parameter estimate of regression coefficient
	x(1) = value of covariate
ANCOVA Model to test for equal slopes: y(ij) = beta(0) + tau(i) + beta(i)x(i,j) + error(ij)
	beta(i) = regression (slope) coefficient for treatment i
Hypotheses:
	ANOVA test for factor:
	H0: tau(1)=tau(2)=...=tau(N)=0
	Ha: at least one tau(i) != 0
	... same hypotheses for other factors, interactions as well
		--> SStrt = SSr2 - SSfull
	Covariate test:
	H0: beta(1) = 0
	Ha: beta(1) != 0
		--> SScov = SSr1 - SSfull
*/

** example;

data oyster;
	input Trt Rep Initial Final;
	cards;
1 1 27.2 32.6
1 2 32.0 36.6
1 3 33.0 37.7
1 4 26.8 31.0
2 1 28.6 33.8
2 2 26.8 31.7
2 3 26.5 30.7
2 4 26.8 30.4
3 1 28.6 35.2
3 2 22.4 29.1
3 3 23.2 28.9
3 4 24.4 30.2
4 1 29.3 35.0
4 2 21.8 27.0
4 3 30.3 36.4
4 4 24.3 30.5
5 1 20.4 24.6
5 2 19.6 23.4
5 3 25.1 30.3
5 4 18.1 21.8
;
run;

* plot regression lines;
proc plot data=oyster;
	*by trt;
	 plot final*initial=trt;
run;
quit;

proc glm data=oyster;
	class trt; * only put categorical variable in class statement;
	model final = initial trt / solution;
	LSmeans trt;
	contrast 'control vs. treatment' trt 1 1 1 1 -4;
	contrast 'bottom vs. top' trt 1 -1 1 -1 0;
	contrast 'hot vs. cold' trt 1 1 -1 -1 0;
run;
quit;

* Test linearity: adding initial*initial to model (squared term) does not add a significant effect
	this confirms linearity;
* Test same slopes: adding initial*trt to model (different slopes term) does not add a significant effect
	this confirms same slope; 
** note that Type 1 SS >= Type 3 SS --> generally Type 3 is the better one to look at
	Type 1 SS adds to TSS, Type 3 SS doesn't add to anything of significance;
** beta-1 = parameter estimate for initial = 1.083

** Test for equal variances;

* calculate mean;
proc means data=oyster;
	var initial;
run; --> *25.7600;

* add new column with y-mean;
data oyster; set oyster;
	final_adj = Final - 1.083179819*(Initial - 25.7600000);
run;

* levene test shows no sig p-value, thus no rejection of equal variances;
proc glm data=oyster;
	Title 'Homogeneity of variances';
	class trt;
	model final_adj = trt;
	means trt / hovtest = levene; 
run;
quit;


** Random/Mixed model;
/*
one-way ANCOVA Model: y(ij) = mu + tau(i) + error(ij)
	* add factors, blocks, interactions as necessary
Random Hypotheses:
	H0: sigma_tau^2 = 0
	Ha: sigma_tau^2 > 0
*/

* example;

* do loop to enter data stack stacked;
data temp;
	do mode = 'I', 'C', 'S';
		do temperature = 1 to 4;
			do rep = 1 to 2; * this will add an extra variable that is not actually needed;
				input y @@; * tells SAS to keep reading;
				output;
			end;
		end;
	end;
	cards;
12 16 15 19 31 39 53 55 15 19 17 17 30 34 51 49 11 17 24 22 33 37 61 67
;
run;

* factorial random with interaction;
proc glm data = temp;
	class mode temperature; 
	model y = mode | temperature / solution; * | does the same as putting all possible combos: 
								mode temperature mode*temperature;
	random temperature mode*temperature / test; * need explicitly to put all 
													effects that are random;
run;
quit;

** result without /test code does not give correct output;
** results output last table showing how MS is built for each factor;
** results do not give the variance for the effects;

* we could also use proc mixed effect model;
proc mixed data = temp;
	title 'Mixed Effect Model';
	class mode temperature;
	model y = mode; * model statement in proc mixed should only contain the fixed factor;
	random temperature mode*temperature;
run;
quit;

** Nested design;
/*
Nested model: y(ijk) = mu + tau(i) + beta(j(i)) + error(ijk)
		i = 1,2  j = 1,2,3  k = 1,2,3,4,5
*/

* example;

* input data usign do loop;
data contentuniform;
	do site = 1 to 2;
		do batch = 1 to 3;
			do tablet = 1 to 5;
				input y@@; * don't need @@ because there is one observation per row;
				output;
			end;
		end;
	end;
	cards;
5.03
5.10
5.25
4.98
5.05
4.64
4.73
4.82
4.95
5.06
5.10
5.15
5.20
5.08
5.14
5.05
4.96
5.12
5.12
5.05
5.46
5.15
5.18
5.18
5.11
4.90
4.95
4.86
4.86
5.07
;
run;

** theoretical model for nested design: y(ijk) = mu + site(i) + batch(j(i)) + error(ijk)
		i = 1,2  j = 1,2,3  k = 1,2,3,4,5
		site is fixed   batch is random;

* correct proc glm procedure using /test;
proc glm data=contentuniform;
	class site batch;
	model y = site batch(site) / E1; * this specificies to only give type 1 SS, E3 would give only type 3 SS;
	random batch(site) / test; * need to include / test to get correct test due to random effect;
	*test H=site E=batch(site); * this "test H statment" can used to build your own F-test 
									H=numerator of F-test, E=denominator of F-test;
run;
quit;

* we can also use proc mixed;
proc mixed data = contentuniform;
	class site batch;
	model y = site;
	random batch(site);
run;
quit;

* we can also use proc nested procedure;
proc nested data = contentuniform;
	class site batch; * which ever is first is the major effect, and those following will be nested in the previous;
	var y;
run;
quit;
