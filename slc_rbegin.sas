%macro slc_rbegin;
  %utlfkil(c:/temp/r_pgm.r);
  %utlfkil(c:/temp/r_pgm.log);
  data _null_;
    file "c:/temp/r_pgm.r";
    input;put _infile_;
%mend slc_rbegin;
