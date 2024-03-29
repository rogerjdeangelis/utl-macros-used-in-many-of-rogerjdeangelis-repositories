%macro utl_data2datastep(dsn,lib,outlib,file,obs,fmt,lbl);
%local varlist fmtlist inputlist msgtype ;
%if %superq(obs)= %then %let obs=MAX;
%let msgtype=NOTE;
%if %superq(dsn)= %then %do;
   %let msgtype=ERROR;
   %put &msgtype: * &SYSMACRONAME ERROR ************************************;
   %put &msgtype: You must specify a data set name;
%syntax:
   %put;
   %put &msgtype- Purpose: Converts a data set to a SAS DATA step.;
   %put &msgtype- Syntax: %nrstr(%%)&SYSMACRONAME(dsn<,lib,outlib,file,obs,fmt,lbl>);
   %put &msgtype- dsn:    Name of the dataset to be converted. Required.;
   %put &msgtype- lib:    LIBREF of the original dataset. (Optional);
   %put &msgtype- outlib: LIBREF for the output dataset. (Optional);
   %put &msgtype- file:   Fully qualified filename for DATA step code. (Optional);
   %put &msgtype-         Default is %nrstr(create_&outlib._&dsn._data.sas);
   %put &msgtype-         in the SAS default directory.;
   %put &msgtype- obs:    Max observations to include the created dataset.;
   %put &msgtype-         (Optional) Default is MAX (all observations);
   %put &msgtype- fmt:    Copy numeric variable formats?;
   %put &msgtype-         (YES|NO - Optional) Default is YES;
   %put &msgtype- lbl:    Copy column labels? ;
   %put &msgtype-         (YES|NO - Optional) Default is YES;
   %put;
   %put NOTE:   &SYSMACRONAME cannot be used in-line - it generates code.;
   %put NOTE-   CAVEAT: Numeric FORMATS in the original data must have a ;
   %put NOTE-           corresponding INFORMAT of the same name.;
   %put NOTE-           Character formats are ingnored.;
   %put NOTE-   Data set label is automatically re-created.;
   %put;
   %put NOTE-   Use ? to print these notes.;
   %put;
   %return;
%end;
%let dsn=%qupcase(%superq(dsn));
%if %superq(dsn)=? %then %do;
   %put &msgtype: * &SYSMACRONAME help ************************************;
   %goto Syntax;
%end;
%if %superq(fmt)= %then %let fmt=YES;
%let fmt=%qupcase(&fmt);
%if %superq(lbl)= %then %let lbl=YES;
%let lbl=%qupcase(&lbl);
%if %superq(lib)= %then %do;
    %let lib=%qscan(%superq(dsn),1,.);
    %if %superq(lib) = %superq(dsn) %then %let lib=WORK;
    %else %let dsn=%qscan(&dsn,2,.);
%end;
%if %superq(outlib)= %then %let outlib=WORK;
%let lib=%qupcase(%superq(lib));
%let dsn=%qupcase(%superq(dsn));
%if %sysfunc(exist(&lib..&dsn)) ne 1 %then %do;
   %put ERROR: (&SYSMACRONAME) - Dataset &lib..&dsn does not exist.;
   %let msgtype=NOTE;
   %GoTo syntax;
%end;
%if %superq(file)= %then %do;
   %let file=create_&outlib._&dsn._data.sas;
   %if %symexist(USERDIR) %then %let file=&userdir/&file;
%end;
%if %symexist(USERDIR) %then %do;
   %if %qscan(%superq(file),-1,/\)=%superq(file) %then
      %let file=&userdir/&file;
%end;
proc sql noprint;
select Name
      into :varlist separated by ' '
   from dictionary.columns
   where libname="&lib"
     and memname="&dsn"
;
select case type
          when 'num' then
             case
                when missing(format) then cats(Name,':32.')
                else cats(Name,':',format)
             end
          else cats(Name,':$',length,'.')
       end
      into :inputlist separated by ' '
   from dictionary.columns
   where libname="&lib"
     and memname="&dsn"
;
%if %qsubstr(%superq(lbl),1,1)=Y %then %do;
select strip(catx('=',Name,put(label,$quote.)))
   into : lbllist separated by ' '
   from dictionary.columns
   where libname="&lib"
     and memname="&dsn"
     and label is not null
;
%end;
%else %let lbllist=;
select memlabel
   into :memlabel trimmed
   from dictionary.tables
   where libname="&lib"
     and memname="&dsn"
;
%if %qsubstr(%superq(fmt),1,1)=Y %then %do;
select strip(catx(' ',Name,format))
      into :fmtlist separated by ' '
   from dictionary.columns
   where libname="&lib"
     and memname="&dsn"
     and format is not null
     and format not like '$%'
;
%end;
%else %let fmtlist=;
quit;
%put _local_;
data _null_;
   file "%superq(file)" dsd;
   if _n_ =1 then do;
   %if %superq(memlabel)= %then %do;
      put "data &outlib..&dsn;";
   %end;
   %else %do;
      put "data &outlib..&dsn(label=%tslit(%superq(memlabel)));";
   %end;
      put @3 "infile datalines dsd truncover;";
      put @3 "input %superq(inputlist);";
   %if not (%superq(fmtlist)=) %then %do;
      put @3 "format %superq(fmtlist);";
   %end;
   %if not (%superq(lbllist)=) %then %do;
      put @3 "label %superq(lbllist);";
   %end;
      put "datalines4;";
   end;
   set &lib..&dsn(obs=&obs) end=__last;
   put &varlist @;
   if __last then do;
      put;
      put ';;;;';
   end;
   else put;
run;
data _null_;
   file "%superq(file)" dsd;
   if _n_ =1 then do;
   %if %superq(memlabel)= %then %do;
      putlog "data &outlib..&dsn;";
   %end;
   %else %do;
      putlog "data &outlib..&dsn(label=%tslit(%superq(memlabel)));";
   %end;
      putlog @3 "infile datalines dsd truncover;";
      putlog @3 "input %superq(inputlist);";
   %if not (%superq(fmtlist)=) %then %do;
      putlog @3 "format %superq(fmtlist);";
   %end;
   %if not (%superq(lbllist)=) %then %do;
      putlog @3 "label %superq(lbllist);";
   %end;
      putlog "datalines4;";
   end;
   set &lib..&dsn(obs=&obs) end=__last;
   putlog &varlist @;
   if __last then do;
      putlog;
      putlog ';;;;';
   end;
   else putlog;
run;
%mend utl_data2datastep;
