* input data;
data soybeans;
	input Yields Mn$ Cu$;
	cards;
1558	20	1
1578	20	1
1590	20	3
1610	20	3
1558	20	5
1550	20	5
1328	20	7
1427	20	7
2003	50	1
2033	50	1
2020	50	3
2051	50	3
2003	50	5
2010	50	5
2010	50	7
2031	50	7
2490	80	1
2470	80	1
2620	80	3
2632	80	3
2490	80	5
2690	80	5
2887	80	7
2832	80	7
2830	110	1
2810	110	1
2860	110	3
2841	110	3
2830	110	5
2910	110	5
2960	110	7
2941	110	7
;
run;

proc print data=soybeans;
run;

* run factorial treatment ANOVA test;
proc glm data = soybeans;
	class Mn Cu;
	model Yields = Mn Cu Mn*Cu / solution;
run;
