*** problem 1;
* input data;
data storms;
	input Station  Intensities;
	cards;
1 20
1 1050
1 3200
1 5600
1 50
2 4300
2 70
2 2560
2 3650
2 80
3 100
3 7700
3 8500
3 2960
3 3340
;
run;

* as one-way anova, fixed effect CRD;
proc glm data=storms;
	class station;
	model intensities = station / solution;
run;
quit;

* as random effect CRD;
proc glm data=storms;
	class station;
	model intensities = station / solution;
	random station;
run;
quit;

*** problem 2;
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

proc print data=temp;
run;

* simple two-way factorial;
proc glm data = temp;
	class mode temperature;
	model y = mode temperature / solution;
run;
quit;

* factorial fixed with interaction;
proc glm data = temp;
	class mode temperature; 
	model y = mode | temperature / solution; * does the same as putting all possible combos: 
								mode temperature mode*temperature;
run;
quit;

* factorial random with interaction;
proc glm data = temp;
	class mode temperature; 
	model y = mode | temperature / solution; * | does the same as putting all possible combos: 
								mode temperature mode*temperature;
	random temperature mode*temperature / test; * need explicitly to put all effects that are random;
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

** results output only the results of the testing mode (fixed effect);
** results do output the variance of effects;
