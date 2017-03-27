* input data;
data attentionspan;
	input child a1p1 a2p1 a3p1 a1p2 a2p2 a3p2;
	cards;
1	19	19	37	39	30	51
2	36	35	6	18	47	52
3	40	22	28	32	6	43
4	30	28	4	22	27	48
5	4	1	32	16	44	39
6	10	27	16	2	26	33
7	30	27	8	36	33	56 
8	5	16	41	43	48	43
9	34	3	29	7	23	40
10	21	18	18	16	21	51
;
run;

proc print attentionspan;
run;

data attentionspan_flat; set attentionspan;
	age = 'a1'; product = 'p1'; span = a1p1; output;
	age = 'a2'; product = 'p1'; span = a2p1; output;
	age = 'a3'; product = 'p1'; span = a3p1; output;
	age = 'a1'; product = 'p2'; span = a1p2; output;
	age = 'a2'; product = 'p2'; span = a2p2; output;
	age = 'a3'; product = 'p2'; span = a3p2; output;
	keep span child age product;
run;

proc print data=attentionspan_flat;
run;

proc glm data=attentionspan_flat;
	class age product;
	model span = age product age*product;
run;
quit;

* 
