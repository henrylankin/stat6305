* input data with do loop;
data tablethardness_looped;
	do batch = 1 to 3;
		do sample 1 to 3;
			do rep 1 to 7;
				input response@@;
				output;
			end;
		end;
	end;
	cards;
'Response'
85
94
91
98
85
96
93
76
87
90
91
88
94
96
95
98
94
96
99
100
93
108
100
105
109
104
102
108
117
106
103
109
100
104
102
101
108
100
99
117
109
105
71
85
78
68
85
67
76
81
70
84
83
72
81
78
72
68
80
72
75
79
74
;
run;

proc print data=tablethardness_looped;
run;


* input data with stacked data;
data tablethardness;
	input Sample$ Batch$ Response;
	cards;
1	1	85
1	1	94
1	1	91
1	1	98
1	1	85
1	1	96
1	1	93
2	1	76
2	1	87
2	1	90
2	1	91
2	1	88
2	1	94
2	1	96
3	1	95
3	1	98
3	1	94
3	1	96
3	1	99
3	1	100
3	1	93
1	2	108
1	2	100
1	2	105
1	2	109
1	2	104
1	2	102
1	2	108
2	2	117
2	2	106
2	2	103
2	2	109
2	2	100
2	2	104
2	2	102
3	2	101
3	2	108
3	2	100
3	2	99
3	2	117
3	2	109
3	2	105
1	3	71
1	3	85
1	3	78
1	3	68
1	3	85
1	3	67
1	3	76
2	3	81
2	3	70
2	3	84
2	3	83
2	3	72
2	3	81
2	3	78
3	3	72
3	3	68
3	3	80
3	3	72
3	3	75
3	3	79
3	3	74
;
run;

proc print data=tablethardness;
run;

proc glm data=tablethardness;
	class batch sample;
	model response = batch sample(batch);
	random batch sample(batch) / test;
run;
quit;
