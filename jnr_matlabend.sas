%macro jnr_matlabend(
    return=
   )/des="execute matlab script";
run;
  %local pth;
  %let pth=%sysfunc(pathname(work));

  options noxwait noxsync;
  filename rut pipe  "C:\Progra~1\GNUOCT~1\Octave-11.3.0\mingw64\bin\octave-cli &pth/matlab_resolve.m ";
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

%mend jnr_matlabend;
