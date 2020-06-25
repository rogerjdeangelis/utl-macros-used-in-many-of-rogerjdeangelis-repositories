%macro xpy()/cmd parmbuff;

%let afstr1=&syspbuff;

/*-----------------------------------------*\
|  xplo %str(ONE TWO THREE)                 |
|  lower case letters produce spaces        |
\*-----------------------------------------*/

note;notesubmit '%xpya';

%mend xpy;

%macro xpya
/  des = "Exploded Banner for Printouts";

%local uj revslash;

options noovp;
title;
footnote;

data _null_;
   rc=filename('__xplp', "%sysfunc(pathname(work))/__xplp");
   if rc = 0 and fexist('__xplo') then rc=fdelete('__xplp');
   rc=filename('__xplp');
run;

%let revslash=%sysfunc(translate(%sysfunc(pathname(work)),'/','\'));
%put &=revslash;
run;quit;

* note uou can altename single and double quotes;
%utl_submit_py64_38(resolve('
import sys;
from pyfiglet import figlet_format;
txt=figlet_format("&afstr1.", font="standard");
with open("&revslash./__xplp", "w") as f:;
.    f.write(txt);
'));

filename __dm clipbrd ;

   data _null_;
     infile "%sysfunc(pathname(work))/__xplp" end=dne;
     file __dm;
     input;
     _infile_=translate(_infile_,"`","'");
     if _n_=1 then substr(_infile_,1,2)='/*';
     putlog _infile_;
     put _infile_;
     if dne then do;
        put '*/';
        putlog '*/';
     end;
   run;

filename __dm clear;

%mend xpya;