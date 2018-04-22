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

proc print data=soil_flat;
run;

proc glm data=soil_flat;
	class calcium ph;
	model diameter = calcium ph ph*calcium / solution;
	contrast '100,200 vs. 300' calcium 1 1 -2;
	contrast '100 vs. 200' calcium 1 -1 0;
run;
quit;

* results: interaction plot shows non-orderly interactions
	should then only examine the interaction and not look at the main effect;
* the baseline level of treatment is not included in the SAS model;
* hypotheses of contrast:
	H0: mu100 + mu200 - 2mu300 = 0
	Ha: mu100 + mu200 - 2mu300 != 0;
* contrast statement degree of freedom always = 1;
* MScontrast = SScontrast/dfcontrast = SScontrast/1 = SScontrast
	F teststat = MScontrast/MSerror;
