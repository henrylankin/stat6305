*** exercise 1;
* input data usign do loop;
data contentuniform;
	do site = 1 to 2;
		do batch = 1 to 3;
			do tablet = 1 to 5;
				input y; * don't need @@ because there is one observation per row;
				output;
			end;
		end;
	end;
	cards;
5.03
5.10
5.25
4.98
5.05
4.64
4.73
4.82
4.95
5.06
5.10
5.15
5.20
5.08
5.14
5.05
4.96
5.12
5.12
5.05
5.46
5.15
5.18
5.18
5.11
4.90
4.95
4.86
4.86
5.07
;
run;

proc print data=contentuniform;
run;

** theoretical model for nested design: y(ijk) = mu + site(i) + batch(j(i)) + error(ijk)
		i = 1,2  j = 1,2,3  k = 1,2,3,4,5
		site is fixed   batch is random;

* nested glm procedure;
proc glm data = contentuniform;
	class site batch;
	model y = site batch(site); * batch is nested in site so we put batch(site) for the variable;
	random batch(site); * only batch is the random effect;
run;
quit;

** Hypotheses and Results
* test for site:
H0: tau(i) = 0
Ha: at least one tau(i) is not 0 ** fixed hypothesis

F-stat = 1.51
	work: F-stat = MSsite/MSE = 0.018/0.012 but this is wrong it should be MSsite/MSbathc(site) = 0.018/0.114
p-value = 0.2311

* test for batch(stie):
H0: sigma^2 of beta = 0
Ha: sigma^2 for beta > 0 ** random hypothesis

F-stat = 9.39
	work: F-stat = MSbatch(site)/MSE = 0.114/0.012 which is correct regardless of random effect
p-value = 0.0001
;

* correct proc glm procedure using /test;
proc glm data=contentuniform;
	class site batch;
	model y = site batch(site) / E1; * this specificies to only give type 1 SS, E3 would give only type 3 SS;
	random batch(site) / test; * need to include / test to get correct test due to random effect;
	*test H=site E=batch(site); * this "test H statment" can used to build your own F-test 
									H=numerator of F-test, E=denominator of F-test;
run;
quit;

* to accomplish the above procedure we can also use proc mixed;
proc mixed data = contentuniform;
	class site batch;
	model y = site;
	random batch(site);
run;
quit;

* we can also use proc nested procedure;
proc nested data = contentuniform;
	class site batch; * which every is first is the major effect, and those following will be nested in the previous;
	var y;
run;
quit;

** results
degree freedom of the batch is the sum of each degree of freedom of the batch within the site: 3-1 + 3-1 = 4
this procedure assumes all factors are random 
;

*** exercise 2;
* input data using do loop;
data machineheads;
	do head = 1 to 4;
		do machine = 'A', 'B', 'C', 'D', 'E';	
			do repeats = 1 to 4;
				input y@@;
				output;
			end;
		end;
	end;
	cards;
6 13 1 7 10 2 4 0 0 10 8 7 11 5 1 0 1 6 3 3
2 3 10 4 9 1 1 3 0 11 5 2 0 10 8 8 4 7 0 7
0 9 0 7 7 1 7 4 5 6 0 5 6 8 9 6 7 0 2 4
8 8 6 9 12 10 9 1 5 7 7 4 4 3 4 5 9 3 2 0
;
run;
	
proc print data=machineheads;
run;

* proc glm procedure with "/ test statement";
proc glm data = machineheads;
	class machine head;
	model y = machine head(machine);
	random head(machine) / test;
run;
quit;

** hypotheses and results:
theoretical model: y(ijk) = mu + tau(i) + beta(j(i)) + error(ijk)
					i = 1,2,3,4,5  j = 1,2,3,4   k = 1,2,3,4
test of machine [fixed effect]:
hypothesis:
H0: tau(i) = 0, for all i
Ha: at least one tau(i) does not = 0

F-stat = 1.26 = MSmachine/MShead(machine) = 11.27/8.96
p-value = 0.3295 -- not significant

test of head(machine) [random effect]:
hypothesis:
H0: sigma^2 of beta = 0
Ha: sigma^2 of beta > 0

F-stat = 0.68 = MShead(machine)/MSE = 8.96/13.18
p-value = 0.7935 -- not significant
;
