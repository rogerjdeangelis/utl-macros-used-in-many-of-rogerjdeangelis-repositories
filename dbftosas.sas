%macro dbftosas(in,out,del=N,control=control.sas,formats=1,obs=9999999,
      revdate=04APR96,
      firstobs=1,append=0,runpgm=1,stream=0,parms=0,
      rename=0,editnams=1,
      stmts=data drop stop run);

 /* http://mcdc.missouri.edu/sas/macros/dbftosas.sas */
 %*--with more mods by jgb, mscdc--*;
 %*--JGB: use of _eod flag to sense end-of-data was not working and we were
   losing a record/obs.  Mod to correct made 5/95--;

 %*--JGB: adding rename parm 6-1-95--;
 %*--JGB: adding explicit length to $rename format ref if used. 11-25-95;
 %*--del parm can by Y to keep deleted records and del variable, N to
   check for and omit deleted records, or (JGB addition) I to ignore
 the delete flag, i.e. drop it and do not check for it.;
 %*--adding line to upase del parm. 1-26-96-;
 %*--adding checks for in and out parms: if they do not contain periods or
   slashes then we shall assume they are filerefs, not physical filenames.
   jgb, 2-20-96--;
 %*--changed all START to _START after failed when input file had a variable
   (field) named START-;
 %*--added editnams parm (with default of true) to have macro edit var names
   instead of substituting a sure-to-be-unique but non-mnemonic name;
 %*--changing name of loop var from J to _J to avoid confict with input field
   of the same name.;
 %*-control parm can be used to specify name of sas source file written;
 %*-formats=0 will cause format statements to NOT be generated-;
 %*-obs parm can be used to limit number of obs to process when reading the
  data file.  Real value will be left as comment-;
 %*-firstobs specifies skipping over recs at start of file-;
 %*-append=1 will cause output to be appended to control file-;
 %*-runpgm parm lets user specify not to include generated code by specifying
  runpgm=0 -;
 %*-stream=1 will cause generated code to be streamed within 80 col recs;
 %*-parms=1 will cause parms to be listed with brief explanations;
 %*-rename=1 tells the pgm that you have created a SAS format code called
  $rename that will serve as a lookup table to rename variables. For
   example if the "value $rename" statement contains:
  "firstname"="fname"  "street"="address"  "zipcode"="zip"
   then these 3 variables would be renamed (to fname, address and zip)
   on the output SAS dataset.  Variables not included in the format will
   be left as is.  Then length spec for the $rename format will be forced to
   8, i.e. we use $rename8. (mod 11-25-95)--;
 %*-editnams=1 tells the pgm to edit variable names longer than 8 chars. by
 removing right-most vowels (aeiou) until length le 8 and truncating after
 that if name is still too long. introduces some danger of dup names.  if
 editnams=0 then pgm generates meaningless but sure-not-to-dup names.
 (jgb, 3-19-96)--;
 %*-stmts=<data drop stop run> can be used to specify that only certain SAS
    statements will be generated.  Use when generating just part of a
    data step.  For example to invoke macro to read 4 dbf files as one
    step use stmts=data on 1st invocation, stmts= on next 2 and
    stmts=drop stop run on last invocation.-;


%put %str( ) ;
%put %str( ) Macro to convert dbase file to SAS dataset Ver 2.1 ;
%put %str( ) Author Richard Hockey DPH August 1994 ;
%put %str( ) ;
%put %str( ) With mods by John Blodgett, UMSL.  Rev. &revdate ;
%put %str( ) ;

%let del=%upcase(&del);  %*--added 1-26-96, JGB--;
%if %quote(&in)= or &PARMS %then %do;
  %put %str(  ) Usage: ;
  %put %str(  )
  %str(Parmlist: IN= ,OUT= ,CONTROL=,APPEND=,OBS=,RUNPGM=,STREAM=,FIRSTOBS=,);
  %put %str(   EDITNAMS=,FORMATS=,STMTS=);
  %put %str(  ) Parameters are: ;
  %put %str(  ) IN dbase file name (eg something.dbf) without quotes.;
  %put %str(  ) **If IN  parm has no slashes or periods then;
  %put %str(  ) ** will be assumed to be fileref, not physical name**;
  %put %str(  ) OUT output SAS dataset. ;
  %put %str(  ) DEL Keep deleted records Y/N (Default=N). ;
  %put %str(  ) CONTROL Name of file containing generated SAS code ;
  %put %str(  ) APPEND=1 will cause SAS code to be appended to control file;
  %put %str(   ) Default is 1 (yes), specify 0 to suppress it;
  %put %str(  ) OBS specifies # of obs. to generate. Default is to read;
  %put %str(  ) RUNPGM controls whether to submit generated code. Default;
  %put %str(   ) is 1 (yes), specify 0 to suppress submit statement;
  %put %str(  ) STREAM can be used to stream the format and input stmts;
  %put %str(   ) rather than start each variable on a new line. Default;
  %put %str(   ) is 0 (do NOT stream), specify 1 to get streaming;
  %put %str(  ) RENAME=1 tells macro to use $rename format code to;
  %put %str(  )  rename fields/variables on output;
  %put %str(  ) EDITNAMS=1 tells macro to edit names longer than 8 ;
  %put %str(  )  chars (after rename) by removing vowels on right and;
  %put %str(  )  then truncating, if necessary. ;
  %put %str(  ) PARMS=1 will cause these parm descriptions to print;
  %put %str(  ) STMTS= can be used to specify generating only certain ;
  %put %str(   ) SAS statements. Value can contain any one or more of;
  %put %str(   ) the words data, drop, stop, run. Use when generating;
  %put %str(   ) just part of a DATA step;
  %put %str(   );
  %IF %quote(&in) eq %then %goto endmacro;
%end;
%local mod;
%if &append %then %let mod=mod; %else %let mod=;
%local data drop stop run;
%let data=%index(&stmts,data); %let drop=%index(&stmts,drop);
%let stop=%index(&stmts,stop); %let run =%index(&stmts,run);

/* determine byte order */
data _null_;
if put(input('1234'x,ib2.),hex4.)='1234' then endian='BIG ';
  else if put(input('1234'x,ib2.),hex4.)='3412' then endian='LITTLE';
else put "Can't determine byte order of this computer!!";
 %if &parms %then %str(put endian=;);
call symput('endian',endian);
run;
%if &endian= %then %goto endmacro;
data _temp ;
%*--mod 2-20-96, jgb: allow in parm to be fileref of physical name--;
 infile
 %if %index(%quote(&in),%quote(/))=0 and %index(%quote(&in),%str(.))=0
  and %index(%quote(&in),%quote(\))=0
  %then &in ;  %else "&in";
  %str( )   recfm=n lrecl=256;
length fmt $ 10;
input vn pib1. year ib1. month ib1. day ib1.  nr $4. hs $2. lr $2. +20 @;
%if &endian=BIG %then %do;
  nr=reverse(nr);
  hs=reverse(hs);
  lr=reverse(lr);
%end;
nrec=input(nr,ib4.);
heads=input(hs,ib2.);
lenrec=input(lr,ib2.);
nfields=int(heads/32)-1;
call symput('_nr',left(put(nrec,12.)));
call symput('_lenrec',left(put(lenrec,6.)));
call symput('_hs',left(put(heads,12.)));
put;
put "Date of dbf file= " day z2. "/" month z2. "/" year;
put "Version= " vn;
put "Number of Fields= " nfields ;
put "Number of Records= " nrec;
put "Length of Header= " heads ;
put "Length of Records= " lenrec ;
put;
do i=1 to nfields;
 input name $11.  type $1. +4 flen pib1. fdec ib1. +14 @;
 name=compress(name,'00'x);  *<--remove any embedded nulls--;
 %if &rename %then %do;
  %*--rename variables using $rename format code.  user has to define it;
 length _tempnm_ $11;
 *-these var names come padded with hex zeroes and we want blanks*;
 _tempnm_=translate(name,'20'x,'00'x) ;  drop _tempnm_;
 name=put(_tempnm_,$rename8.);
 if name ne _tempnm_ then do;
   file log;  _nrenam_+1;  drop _nrenam_;
   if _nrenam_=1 then put /'Fields to be renamed as SAS Variables '
            'using $rename format';
   put _tempnm_ $12. '=' name;
   end;
 %end;


 if first^=1 then do;
 file "&control" lrecl=80 &mod;  %*<--append parm used here;
 first=1;
 %if &data %then %str(put "DATA &out;";);
 %if &formats %then %str(put "  FORMAT " ;);
 end;
 %if &editnams %then %str( link editvwls; );
  %else %do;  %*--original code to handle the case (by RH)--;
 name=substr(name,1,verify(name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_')-1);
 if length(name)>8 then do;
  file log;
  vcount+1;
  name1="VDB"||put(vcount,z2.);
  put "Variable " name " too long, changed to " name1;
  name=name1;
 end;
  %end;


 if type in('C','L') then do;
  if flen > 200 or fdec > 0 then do;
  file log;
  put "Variable " name " Field length too long, truncated to 1st 200 character
s" /;
;
  fmt="$200.";
  end;
  else
  fmt="$"||trim(left(put(flen,8.)))||".";
 end;
 else if type in('N','F')  then
  fmt=trim(left(put(flen,8.)))||"."||trim(left(put(fdec,8.)));
 else if type='D' then
  fmt="DDMMYY6.";
 file "&control" lrecl=80;
 %if &stream %then %let trailat=%str(+2 @); %else %let trailat= ;
 %if &formats %then %do;
 if type^='M' then
 put name  fmt  &trailat;
 %end;
 output;
end;
%if &rename %then %do;
  file log; put _nrenam_ ' variables renamed using $rename format.';
  file "&control";
  %end;
put ";";
stop;
%if &editnams %then %do;
editvwls:
  length _work $11;
  name=translate(name,'20'x,'00'x);
  _ln=length(name);
  if _ln gt 8 then do;
  _work=upcase(left(reverse(name)));
  newlen=_ln;
  do __i=1 to _ln-1;
  length _a $1; _a=substr(_work,__i,1);
  if index('AEIOU',_a) then do;
    substr(_work,__i,1)='ff'x;
    newlen=newlen-1;
    end;
  if newlen le 8 then leave;
  end;
  _work=left(reverse( compress(_work,'ff0d'x)) );
  if length(_work) gt 8 then do;
  name=substr(_work,1,8);
  end;
  else name=_work;
  end;
  drop _work newlen __i _a _ln;
  return;
  %end;  %*--editvwls linked-to routine (optional)--;
run;
data _null_;
 set _temp end=eof;
length range $ 25 ;
file "&control" mod lrecl=80;
if _n_ =1 then do;
  put "INFILE "
 %if %index(%quote(&in),%quote(/))=0 and %index(%quote(&in),%str(.))=0
  %then "&in";  %else "'&in'"  ;
 +1 "recfm=n lrecl=256 end=_eod;";
  put "_START= &_hs ;";
  put "INPUT +_START @;" ;
  %if &obs gt &_NR %then %let obs=&_NR; %*<===fix, 5-31-95, jgb--;
  put "DO _J=1 TO &obs ; ** &_NR ;" ; *<===much different;
 %if &firstobs gt 1 %then %do;
  put  "IF _J LT &FIRSTOBS THEN DO;"/
   "  *--flush the record--; " /
   "input + &_lenrec @;  goto endjloop;" /
   "end; ";
   %end;
  put "INPUT  del $1. " ;
end;
if type='D' then
  range=" "||name||" YYMMDD"||trim(left(put(flen,8.)))||". " ;
 else if type in("C","L") then do;
 if  flen > 200 or fdec > 0 then do;
   if fdec=0 then
   range=name||" $200."||" +"||trim(left(put((flen-200),8.))) ;
   else
   range=name||" $200."||" +"||trim(left(put(((flen+(fdec*256))-200),8.)));
 end;
 else
   range=name||" $"||trim(left(put(flen,8.)))||". ";
 end;
 else if type in('N','F') then
   range=name||" "||trim(left(put(flen,8.)))||"."||trim(left(put(fdec,8.)));
 else if type='M' then
   range="+10" ;
put range  &trailat ;
if eof then do;
  put "@ ;" ;
  %if &del=N %then %do;
  put "IF DEL^='*' THEN OUTPUT;";
  put "ELSE DO;";
  put "  FILE LOG;";
  put "  PUT 'RECORD ' _J ' DELETED';";
  put "END;";
  %end;
  %else %do;
  put "OUTPUT;";
  %end;
  %if &firstobs gt 1 %then %do;  put "ENDJLOOP:"; %end;
  put "END;";
  %if &drop %then %do;
  put "DROP ";
  %if &del=N or &del=I %then %do;
    put " DEL";
    %end;
  put " _START _J;";
  %end;

  %if &stop %then %str(  put "STOP;";);
  %if &run  %then %str(  put "RUN;" ;);
  end;
run;
%if &runpgm %then %do;
  %inc "&control";
  %end;
%endmacro:
%mend dbftosas;

