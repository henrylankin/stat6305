data sleepduration;
	input Sequence$	Patient$	Period$	Response;
	cards;
1	1	1	8.6
1	2	1	7.5
1	3	1	8.3
1	4	1	8.4
1	5	1	6.4
1	6	1	6.9
1	7	1	6.5
1	8	1	6
1	1	2	8
1	2	2	7.1
1	3	2	7.4
1	4	2	7.3
1	5	2	6.4
1	6	2	6.8
1	7	2	6.1
1	8	2	5.7
2	9	1	7.3
2	10	1	7.5
2	11	1	6.4
2	12	1	6.8
2	13	1	7.1
2	14	1	8.2
2	15	1	7.2
2	16	1	6.7
2	9	2	7.9
2	10	2	7.6
2	11	2	6.3
2	12	2	7.5
2	13	2	7.7
2	14	2	8.6
2	15	2	7.8
2	16	2	6.9
;
run;

proc print data=sleepduration;
run;

data sleepduration; set sleepduration;
	length treatment $ 10;
	if mod(period + sequence, 2)=0 then treatment = 'drug';
		else treatment = 'placebo';
run;

proc print data=sleepduration;
run;

* use proc glm just to get the interaction plot between sequence and treatment;
proc glm data = sleepduration;
	class sequence treatment;
	model response = sequence treatment sequence*treatment;
run;
quit;

* use proc glm just to get the interaction plot between period and treatment;
proc glm data = sleepduration;
	class period treatment;
	model response = period treatment period*treatment;
run;
quit;

* use proc glm just to get the interaction plot between sequence and period;
proc glm data = sleepduration;
	class period sequence;
	model response = period sequence period*sequence / solution;
run;
quit;

* test for crossover design;
proc glm data = sleepduration;
	class sequence patient period treatment;
	model response = sequence patient(sequence) period treatment treatment*period;
	random patient(sequence) / test;
run;
quit;
