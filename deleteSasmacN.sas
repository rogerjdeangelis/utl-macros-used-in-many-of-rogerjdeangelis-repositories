%macro deleteSasmacN()
   /des="Delete all numberes sasmacr# libraries. does not delete sasnacr";
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
proc datasets lib=work mt=cat ;
  delete &_catNam;
run;quit;
%mend deleteSasmacN;
