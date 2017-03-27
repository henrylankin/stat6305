*** Excersice 17.10

* input data;
data chemicalants;
	input Locations$	Chemicals$	NumberKilled;
	cards;
1	1	7.2
1	1	9.6
2	1	8.5
2	1	9.6
3	1	9.1
3	1	8.6
4	1	8.2
4	1	9
5	1	7.8
5	1	8
1	2	4.2
1	2	3.5
2	2	2.9
2	2	3.3
3	2	1.8
3	2	2.4
4	2	3.6
4	2	4.4
5	2	3.7
5	2	3.9
1	3	9.5
1	3	9.3
2	3	8.8
2	3	9.2
3	3	7.6
3	3	7.1
4	3	7.3
4	3	7
5	3	9.2
5	3	8.3
1	4	5.4
1	4	3.9
2	4	6.3
2	4	6
3	4	6.1
3	4	5.6
4	4	5
4	4	5.4
5	4	6.5
5	4	6.9
;
run;

/*proc print data=chemicalants;
run;*/

* fixed, random effect model using proc glm;
proc glm data=chemicalants;
	class locations chemicals;
	model numberkilled = locations | chemicals / solution;
	random locations locations*chemicals / test;
	means chemicals / lsd;
	means chemicals*locations / lsd;
	output out=residuals r=res;
run;
quit;

* mixed effect model using proc mixed;
proc mixed data = chemicalants;
	class locations chemicals;
	model numberkilled = chemicals;
	random locations locations*chemicals;
run;
quit;


proc univariate normal data=residuals;
	var res;
run;
quit;
