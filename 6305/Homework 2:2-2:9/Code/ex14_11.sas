* input data;
data icecream;
	input Ratings Sweetner$ MilkFat$ Air$;
	cards;
23	12%	10%	5%
24	12%	10%	5%
25	12%	10%	5%
36	12%	10%	10%
35	12%	10%	10%
36	12%	10%	10%
28	12%	10%	15%
24	12%	10%	15%
27	12%	10%	15%
27	12%	12%	5%
28	12%	12%	5%
26	12%	12%	5%
34	12%	12%	10%
38	12%	12%	10%
39	12%	12%	10%
35	12%	12%	15%
35	12%	12%	15%
34	12%	12%	15%
31	12%	15%	5%
32	12%	15%	5%
29	12%	15%	5%
33	12%	15%	10%
34	12%	15%	10%
35	12%	15%	10%
26	12%	15%	15%
27	12%	15%	15%
25	12%	15%	15%
24	16%	10%	5%
23	16%	10%	5%
28	16%	10%	5%
37	16%	10%	10%
39	16%	10%	10%
35	16%	10%	10%
26	16%	10%	15%
29	16%	10%	15%
25	16%	10%	15%
38	16%	12%	5%
36	16%	12%	5%
35	16%	12%	5%
34	16%	12%	10%
38	16%	12%	10%
36	16%	12%	10%
36	16%	12%	15%
37	16%	12%	15%
34	16%	12%	15%
34	16%	15%	5%
36	16%	15%	5%
39	16%	15%	5%
34	16%	15%	10%
36	16%	15%	10%
31	16%	15%	10%
28	16%	15%	15%
26	16%	15%	15%
24	16%	15%	15%
;
run;

proc print data=icecream;
run;

* run factorial design anova test;
proc glm data=icecream;
	class Sweetner MilkFat Air;
	model ratings = Sweetner MilkFat Air Sweetner*MilkFat Sweetner*Air MilkFat*Air Sweetner*MilkFat*Air;
	output out=residuals r=res p=fitted;
run;
quit;

* plot residuals qq-plot;
proc univariate normal plot data = residuals;
	var res;
run;
quit;

* plot residuals vs. fitted values to check for equal variances;
proc gplot data=residuals;
	plot res*fitted;
	symbol i=none v=star;
run;
quit;

* time series graph to look at independence of residuals;
proc gplot data=residuals;
	symbol i=line v=star;
	plot res*ratings=1;
run;
quit;

* re-enter data set so as to have one factor: the three factor combination; 
data icecream_oneway;
	length treatment $12;
	input ratings treatment$;
	cards;
23	12%10%5%
24	12%10%5%
25	12%10%5%
36	12%10%10%
35	12%10%10%
36	12%10%10%
28	12%10%15%
24	12%10%15%
27	12%10%15%
27	12%12%5%
28	12%12%5%
26	12%12%5%
34	12%12%10%
38	12%12%10%
39	12%12%10%
35	12%12%15%
35	12%12%15%
34	12%12%15%
31	12%15%5%
32	12%15%5%
29	12%15%5%
33	12%15%10%
34	12%15%10%
35	12%15%10%
26	12%15%15%
27	12%15%15%
25	12%15%15%
24	16%10%5%
23	16%10%5%
28	16%10%5%
37	16%10%10%
39	16%10%10%
35	16%10%10%
26	16%10%15%
29	16%10%15%
25	16%10%15%
38	16%12%5%
36	16%12%5%
35	16%12%5%
34	16%12%10%
38	16%12%10%
36	16%12%10%
36	16%12%15%
37	16%12%15%
34	16%12%15%
34	16%15%5%
36	16%15%5%
39	16%15%5%
34	16%15%10%
36	16%15%10%
31	16%15%10%
28	16%15%15%
26	16%15%15%
24	16%15%15%
;
run;

proc print data=icecream_oneway;
run;

* run one-anova procedure with levene test to test for equal variances;
proc glm data=icecream_oneway;
	class treatment;
	model ratings = treatment;
	means treatment / hovtest=levene;
run;
quit;

* create new data set for only values associated with sweetner=12%;
data icecream_sweetner12; set icecream;
	if Sweetner = '12%';
run;

proc print data=icecream_sweetner12;
run;

* run two facotr factorial design anova test for sweetner=12% to look at interaction plot;
proc glm data=icecream_sweetner12;
	class MilkFat Air;
	model ratings = MilkFat Air  MilkFat*Air;
run;
quit;

* create new data set for only values associated with sweetner=16%;
data icecream_sweetner16; set icecream;
	if Sweetner = '16%';
run;

proc print data=icecream_sweetner16;
run;

* run two factor factorial design anova test for sweetner=16% to look at interaction plot;
proc glm data=icecream_sweetner16;
	class MilkFat Air;
	model ratings = MilkFat Air  MilkFat*Air;
run;
quit;

