%macro loadinfile(str)
  /des="load string into the infile buffer";
 %dosubl('
   data _null_;
     file "%sysfunc(getoption(WORK))/tmp.txt";
     put "*";
   run;quit;
   ');
  infile  "%sysfunc(getoption(WORK))/tmp.txt";
  input @;
  _infile_ = &str;
%mend loadinfile;
