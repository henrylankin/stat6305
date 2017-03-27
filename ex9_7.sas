* ex 19.7;
* input data;
data oxycontent;
	input sample dist1 dist5 dist10 dist20;
	cards;
1 1 4 20 37
2 5 8 26 30
3 2 2 24 26
4 1 3 11 24
5 2 8 28 41
6 2 5 20 25
7 4 6 19 36
8 3 4 29 31
9 0 3 21 31
10 2 3 24 33
;
run;

* print oxycontent data;
proc print data=oxycontent;
run;

* turn oxycontent data into a stacked table;
data oxycontent_flat; set oxycontent;
length treatment $10;
treatment = "dist1"; content = dist1; output;
treatment = "dist5"; content = dist5; output;
treatment = "dist10"; content = dist10; output;
treatment = "dist20"; content = dist20; output;
keep content treatment;
run;

proc print data=oxycontent_flat;
run;

* run glm procedure on stacked table;
* run contrast statement test for the 3 mutually orthogonal contrast statements;
proc glm data=oxycontent_flat;
	class treatment;
	model content = treatment;
	means treatment /deponly;
	contrast '20 vs. 1, 5, 10' treatment 3 -1 -1 -1;
	contrast '10 vs. 1, 5' treatment 0 2 -1 -1;
	contrast '5 vs. 1' treatment 0 0 1 -1;
run;
quit;









