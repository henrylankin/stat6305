data bloodpressure;
	input Drug$	Age$	Non$	BPReduction;
	cards;
D1	A1	ND1	33
D1	A1	ND1	34
D1	A1	ND1	35
D1	A1	ND2	37
D1	A1	ND2	38
D1	A1	ND2	36
D1	A1	ND3	41
D1	A1	ND3	42
D1	A1	ND3	39
D2	A1	ND1	46
D2	A1	ND1	45
D2	A1	ND1	46
D2	A1	ND2	44
D2	A1	ND2	48
D2	A1	ND2	49
D2	A1	ND3	43
D2	A1	ND3	44
D2	A1	ND3	45
D3	A1	ND1	38
D3	A1	ND1	34
D3	A1	ND1	37
D3	A1	ND2	45
D3	A1	ND2	45
D3	A1	ND2	44
D3	A1	ND3	36
D3	A1	ND3	37
D3	A1	ND3	35
D1	A2	ND1	34
D1	A2	ND1	33
D1	A2	ND1	38
D1	A2	ND2	48
D1	A2	ND2	46
D1	A2	ND2	45
D1	A2	ND3	44
D1	A2	ND3	46
D1	A2	ND3	49
D2	A2	ND1	47
D2	A2	ND1	49
D2	A2	ND1	45
D2	A2	ND2	44
D2	A2	ND2	48
D2	A2	ND2	46
D2	A2	ND3	44
D2	A2	ND3	46
D2	A2	ND3	41
D3	A2	ND1	36
D3	A2	ND1	39
D3	A2	ND1	35
D3	A2	ND2	46
D3	A2	ND2	47
D3	A2	ND2	44
D3	A2	ND3	38
D3	A2	ND3	36
D3	A2	ND3	35
;
run;

proc print data=bloodpressure;
run;

proc glm data=bloodpressure;
	class age drug non;
	model BPReduction = age drug non(age) drug*non(age) drug*age / solution;
	*model BPReduction = age drug non(age); * drug*non(age);
	random non(age) drug*non(age) / test;
run;
quit;


