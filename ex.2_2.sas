data prob2;
	input ID $
		  Height /* in inches */
		  Weight /* in pounds */
		  SBP /* systolic BP */
		  DBP /* diastolic BP */;
	WtKg = (1/2.2)*Weight;
	HtCm = 2.54*Height;
	AveBP = DBP + (1/3)*(SBP - DBP);
	HtPolynomial = 2*Height*Height + 1.5*Height*Height*Height;
	HtPolynomial_cm = 2*HtCm*HtCm + 1.5*HtCm*HtCm*HtCm;
datalines;
001 68 150 110 70
002 73 240 150 90
003 62 101 120 80
;

title "Listing of PROB2";
proc print data = prob2;
run;
