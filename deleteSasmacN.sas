%macro deleteSasmacN()
   /des="Delete all numberes sasmacr# libraries. does not delete sasnacr";
%symdel _catNam/nowarn;
%let _catnam=;
proc sql;
  select
     memname
  into
     :_catNam separated by " "
  from
     sashelp.vscatlg
  where
         libname =   "WORK"
     and memname eqt "SASMAC"
     and anydigit(memname)>0
;quit;
%if %length(&_catNam) > 5  %then %do;
  proc datasets lib=work mt=cat ;
     delete &_catNam;
  run;quit;
%end;
%mend deleteSasmacN;
