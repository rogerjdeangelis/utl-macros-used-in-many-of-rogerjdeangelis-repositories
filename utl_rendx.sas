%macro utl_rendx(return=,resolve=Y)/des="utl_rbeginx uses parmcards and must end with utl_rendx macro";
run;quit;
* EXECUTE R PROGRAM;
data _null_;
  infile "c:/temp/r_pgm";
  input;
  file "c:/temp/r_pgmx";
  %if "&resolve"="Y" %then %do;_infile_=resolve(_infile_);%end;
  put _infile_;
run;quit;
options noxwait noxsync;
filename rut pipe "D:\r414\bin\r.exe --vanilla --quiet --no-save < c:/temp/r_pgmx";
run;quit;
data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;quit;
data _null_;
  infile " c:/temp/r_pgm";
  input;
  putlog _infile_;
run;quit;
%if "&return" ne ""  %then %do;
  filename clp clipbrd ;
  data _null_;
   infile clp obs=1;
   input;
   putlog "xxxxxx  " _infile_;
   call symputx("&return.",_infile_,"G");
  run;quit;
  %end;
filename ft15f001 clear;
%mend utl_rendx;
                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                
                            
