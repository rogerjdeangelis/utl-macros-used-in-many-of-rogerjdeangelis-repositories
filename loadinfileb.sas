%macro loadinfileB(str,lrecl=32767)
  /des="load string into the infile buffer";
 %local rc ff filrf fid;
 %let ff = %sysfunc(datetime());
 %let rc=%sysfunc(filename(filrf
   ,%sysfunc(pathname(WORK))/empty&ff..txt));
 %let fid=%sysfunc(fopen(&filrf., a));
 %if &fid. > 0 %then
   %do;
      %let rc=%sysfunc(fwrite(&fid));
      %let rc=%sysfunc(fclose(&fid));
      infile
        "%sysfunc(pathname(WORK))/empty&ff..txt"
         lrecl=&lrecl.;
      input @; _infile_ = &str;
   %end;
 %else
    %do;
      putLOG "ERROR:&sysmacroname. Something";
      putlog "went wrong with the temp file...";
      stop;
    %end;
%mend loadinfileB;
