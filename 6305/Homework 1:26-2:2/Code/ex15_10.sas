* ex 15.10;
* input data;
data mpgblend;
	input driver$ model$ blend$	mpg;
	cards;
1	1	A	15.5
2	1	B	16.3
3	1	C	10.5
4	1	D	14
1	2	B	33.8
2	2	C	26.4
3	2	D	31.5
4	2	A	34.5
1	3	C	13.7
2	3	D	19.1
3	3	A	17.5
4	3	B	19.7
1	4	D	29.2
2	4	A	22.5
3	4	B	30.1
4	4	C	21.6
;
run;

proc print data = mpgblend;
run;

* run glm procedure for anova test;
* estimate parameters of the model;
* output residuals res and fitted values p;
proc glm data = mpgblend;
	class driver model blend;
	model mpg = driver model blend / solution;
	means blend / lsd;
	means blend / tukey;
	output out=residuals r=res p=fitted;
run;
quit;


* plot residuals vs. fitted values;
proc gplot data=residuals;
plot res*fitted;
run;
quit;

* anova test is "faked" into one-way to run levene variance test;
/**
proc glm data = mpgblend;
	class blend;
	model mpg = blend;
	means blend / hovtest=levene;
run;
quit;
*/
