%macro dosubl(arg);
  %local rc;
  %if 0 =  %qsysfunc(dosubl(&arg)) %then %put Completed;
%mend dosubl;
