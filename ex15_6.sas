* ex 15.6;
* input data;
data typing;
	input subject music :$10. score;
	cards;
1	NoMusic		20
2	NoMusic		17
3	NoMusic		24
4	NoMusic		20
5	NoMusic		22
6	NoMusic		25
7	NoMusic		18
1	HardRock	20
2	HardRock	18
3	HardRock	23
4	HardRock	18
5	HardRock	21
6	HardRock	22
7	HardRock	19
1	Classical	24
2	Classical	20
3	Classical	27
4	Classical	22
5	Classical	24
6	Classical	28
7	Classical	16
;
run;

proc print data=typing;
run;

* calculate means by music (treatment);
proc means data = typing;
	class music;
	var score;
	output out = music_means mean = ;
run;

* calculate means by subject (block);
proc means data = typing;
	class subject;
	var score;
	output out = subject_means mean = ;
run;

* run anova test;
* estimate parameters of the model;
proc glm data = typing;
	class subject music;
	model score = subject music / solution;
	output out=residuals r=res;
run;
quit;

proc print data=residuals;
run;
