%macro dosubl(arg);
  %let rc=%qsysfunc(dosubl(&arg));
%mend dosubl;
