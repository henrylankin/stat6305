* Problem 10.1;

libname datasets '\\Mac\Home\Desktop\School\6250\datasets';

*Data set BLOOD;
data datasets.blood;
   infile '\\Mac\Home\Desktop\School\6250\datasets\blood.txt' truncover;
   length Gender $ 6 BloodType $ 2 AgeGroup $ 5;
   input Subject 
         Gender 
         BloodType 
         AgeGroup
         WBC 
         RBC 
         Chol;
   label Gender = "Gender"
         BloodType = "Blood Type"
         AgeGroup = "Age Group"
         Chol = "Cholesterol";
run;

proc print data=datasets.Blood;
run;
