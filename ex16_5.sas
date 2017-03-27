data hypertension;
	length TREATMENT $4;
	input Patient	TREATMENT$	RISK	NOCIG;
	cards;
1	C	22	0
2	C	26	2
3	C	49	6
4	C	67	8
5	C	72	12
6	C	19	0
7	C	28	2
8	C	97	20
9	C	88	18
10	C	30	3
11	one	7	0
12	one	9	0
13	one	14	3
14	one	18	4
15	one	30	7
16	one	42	9
17	one	50	12
18	one	54	13
19	one	70	17
20	one	82	25
21	two	12	0
22	two	14	0
23	two	17	2
24	two	29	5
25	two	37	7
26	two	45	9
27	two	53	11
28	two	81	18
29	two	93	21
30	two	94	23
;
run;

proc print data=hypertension;
run;
* full ANCOVA;
proc glm data=hypertension;
	class treatment;
	model risk = nocig treatment / solution;
	output out=residuals r=res;
run;
quit;

proc print data = residuals;
run;

* test normality;
proc univariate normal plot data=residuals;
	var res;
run;
quit;

* reduced model 1 ANOVA;
proc glm data=hypertension;
	class treatment;
	model risk = treatment;
	output out=residuals_treat r=res;
run;
quit;

* test normality;
proc univariate normal plot data=residuals_treat;
	var res;
run;
quit;

* reduced model 2 regression;
proc glm data=hypertension;
	model risk = nocig;
	output out=residuals_reg r=res;
run;
quit;

* test normality;
proc univariate normal plot data=residuals_reg;
	var res;
run;
quit;

* interaction model to provide SSEinter for check for equal slopes;
proc glm data=hypertension;
	class treatment;
	model risk = nocig treatment nocig*treatment;
	output out=residuals_interact r=res;
run;
quit;
** results from full ANCOVA gives SSEnointeract and interaction model gives SSEinteract
	used to find F=MSbeta4beta5/MSEinteraction ~ (MSEnointeraction-MSEinteraction)/MSEinteraction

* test normality;
proc univariate normal plot data=residuals_interact;
	var res;
run;
quit;

* plot scatterplot to see regression relationship -- already plotted in full model output;
proc plot data=hypertension;
	plot risk*nocig=treatment;
run;
quit;

proc means data = hypertension;
	var nocig;
run;

* add new column with risk_adj;
data hypertension; set hypertension;
	risk_adj = risk - 3.62352665*(nocig - 8.5666667);
run;

* levene test;
proc glm data=hypertension;
	class treatment;
	model risk_adj = treatment;
	means treatment / hovtest = levene;
run;
quit;

proc glm data=hypertension;
	class treatment;
	model risk = treatment nocig nocig*nocig;
run;
quit;

proc glm data=hypertension;
	class treatment;
	model risk = treatment;
	means treatment / hovtest=levene;
run;
quit;
