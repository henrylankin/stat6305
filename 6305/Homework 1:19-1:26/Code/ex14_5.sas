* data entries;
data ex14_5;
input A B C D;
cards;
422 521 437 582
431 545 422 639
784 600 473 735
711 406 478 800
641 563 397 853
709 361 944 748
344 387 394 622
599 700 890 514
511 348 488 714
381 944 521 627
349 545 387 548
387 337 633 644
394 427 627 736
621 771 444 528
328 752 1467 595
636 810 828 572
388 406 644 627
901 537 1154 546
394 816 430 701
350 369 508 664
;
run;

* convert data set into a flat table;
data ex14_5flat; set ex14_5;
method = "A" ; Y=A; output;
method = "B" ; Y=B; output; 
method = "C" ; Y=C; output;
method = "D" ; Y=D; output;
keep Y method;
run;

* run general linear model for ANOVA test;
* run LSD test for mean comparisons;
* create data set of residuals named resids;
proc glm data=ex14_5flat;
class method;
model Y=method;
means method / LSD;
means method / tukey;
means method / hovtest=levene;
output out=resids r=res;
run;
quit;

* test for normality: qq-plot, shapiro-wilks test;
proc univariate normal plot data=resids;
var res;
run;
