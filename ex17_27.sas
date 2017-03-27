*** Excersice 17.27

* input data;
data solders;
	input Operator	Machine	Response;
	cards;
1	1	204
1	1	205
2	1	205
2	1	207
3	1	211
3	1	209
1	2	205
1	2	210
2	2	205
2	2	206
3	2	207
3	2	210
1	3	203
1	3	204
2	3	206
2	3	204
3	3	209
3	3	214
1	4	205
1	4	203
2	4	209
2	4	207
3	4	215
3	4	212
;
run;

/*proc print data=solders;
run;*/

proc glm data = solders;
	class operator machine;
	model response = operator | machine  / solution;
	random operator machine operator*machine / test;
run;
quit;
