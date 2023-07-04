%macro utl_wpsendx(return=);
run;quit;
%put xxxxxx &return;
* EXECUTE THE PYTHON PROGRAM;
options noxwait noxsync;
%let _w=%sysfunc(compbl(C:\progra~1\worldp~1\wpsana~1\4\bin\wps.exe -autoexec c:\oto\Tut_Otowps.sas -config c:\cfg\wps.cfg
         -log c:/temp/wps_pgm.log
         -print c:/temp/wps_pgm.lst
         -sysin c:/temp/wps_pgm.wps));
filename rut pipe "&_w" ;
run;quit;
data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;quit;
data _null_;
  infile "c:/temp/wps_pgm.log";
  input;
  putlog _infile_;
run;quit;
data _null_;
  infile "c:/temp/wps_pgm.lst";
  input;
  file print;
  put _infile_;
run;quit;
* use the clipboard to create macro variable;
%if "&return" ne ""  %then %do;
   data _null_;
    infile clp;
    input;
    putlog "xxxxxxx  " _infile_;
    call symputx("&return",_infile_,"G");
   run;quit;
%end;
%mend utl_wpsendx;
