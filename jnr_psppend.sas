%macro jnr_psppend(
    return=
   )/des="execute spss script";
run;
  %local pth;
  %let pth=%sysfunc(pathname(work));

  options noxwait noxsync;
  filename rut pipe "c:\PROGRA~1\PSPP\bin\pspp.exe &pth/pspp_resolve.sps";
  run;quit;
  data _null_;
    infile rut;
    input;
    putlog _infile_;
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

%mend jnr_psppend;
