* ex9.12;
* input data unstacked;
data deersize;
	input wild ranch zoo;
	cards;
114.7 120.4 103.1
128.9 91.0 90.7
111.5 119.6 129.5
116.4 119.4 75.8
134.5 150.0 182.5
126.7 169.7 76.8
120.6 100.9 87.3
129.59 76.1 77.3
;
run; 

proc print data=deersize;
run;

* convert deersize to stacked table;
data deersizeflat; set deersize;
	treatment = "wild"; size = wild; output;
	treatment = "ranch"; size = ranch; output;
	treatment = "zoo"; size = zoo; output;
	keep size treatment;
run;

proc print data=deersizeflat;
run;

* run anova test for H0: treatment means are equal;
* run multiple comparisons test -- LSD and Tukey;
* test contrast statement (-1,-1,2);
proc glm data=deersizeflat;
	class treatment;
	model size = treatment;
	means treatment / lsd;
	means treatment / tukey;
	means treatment / deponly;
	contrast 'wild,ranch vs. zoo' treatment -1 -1 2;
run;
quit; 
