%macro utl_numary(_inp);
 %symdel _array / nowarn;
 %dosubl(%nrstr(
     filename clp clipbrd lrecl=64000;
     data _null_;
       file clp;
       set &_inp(keep=_numeric_);
       put (_all_) ($) @@;
     run;quit;
     data _null_;
       infile clp;
       input;
       _infile_=compbl(_infile_);
       _infile_=translate(strip(_infile_),',',' ');
       call symputx('_array',_infile_);
     run;quit;
     ))
     &_array
%mend utl_numary;
