%macro jnr_perlEnd(
    return=
   )/des="execute perl script";
run;

  %local pth;
  %let pth=%sysfunc(pathname(work));

  * filename rut pipe "perl.exe -executionpolicy bypass -file &pth/perl_resolve.ps1";
  filename rut pipe "cmd /c c:\strawberry\perl\bin\perl -file &pth/perl_resolve.pl";
  run;quit;

  data _null_;
    infile rut;
    input;
    *putlog _infile_;
    file print;
    put _infile_;
  run;

  filename rut clear;

  * use the clipboard to create macro variable;
  %if "&return" ^= "" %then %do;
    filename clip clipbrd;
    data _null_;
     infile clip;  /*--- created from the SPSS script ---*/
     input;
     putlog "*******  " _infile_ "  ********";
     call symputx("&return",_infile_,"G");
    run;quit;
  %end;

%mend jnr_perlEnd;
