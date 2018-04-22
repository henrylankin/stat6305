data Demo_2006;
   input Name $ Code $ Days Number Price;
   CostPerSeed = Price / Number;
   if days > 60 then expire='yes'; 
   else expire='no';
datalines;
Cucumber 50104-A 55 30   195
Cucumber 51789-A 56 30   225
Carrot   50179-A 68 1500 395
Carrot   50872-A 65 1500 225
Corn     57224-A 75 200  295
Corn     62471-A 80 200  395
Corn     57828-A 66 200  295
Eggplant 52233-A 70 30   225
;
run;

title 'ex 1.1 test - Demo_20063';
proc print 
	data=Demo_2006; 
run;
