%macro bdeleteMacArray(
  arrs
, macarray = N
)
/ minoperator
;
%local I J rc;
%do I = 1 %to %sysfunc(countw(&arrs.));
%let arr = %scan(&arrs., &I., %str( ));
  %do J = &&&arr.LBOUND %to &&&arr.HBOUND;
    /*%put *&arr.&J.*;*/
    %symdel &arr.&J. / NOWARN;
  %end;
  %symdel &arr.LBOUND &arr.HBOUND &arr.N / NOWARN;
%end;

%if %qupcase(&macarray.) in (Y YES) %then
  %do;
  %let rc = %sysfunc(dosubl(
  /*+++++++++++++++++++++++++++++++++++++++++++++*/
  options nonotes nosource %str(;)
  proc sql noprint %str(;)
    create table _%sysfunc(datetime(), hex16.)_ as
    select memname %str(,) objname
    from dictionary.catalogs
    where
      objname in (%upcase(
      %str(%")%qsysfunc(tranwrd(&arrs., %str( ), %str(%",%")))%str(%")
      ))
      and objtype = 'MACRO'
      and libname  = 'WORK'
    order by memname %str(,) objname
    %str(;)
  quit %str(;)
  data _null_ %str(;)
    do until(last.memname) %str(;)
      set _last_ %str(;)
      by memname %str(;)

      if first.memname then
      call execute('proc catalog cat = work.'
                 !! strip(memname)
                 !! ' et = macro force;') %str(;)
      call execute('delete '
                 !! strip(objname)
                 !! '; run;') %str(;)
    end %str(;)
    call execute('quit;') %str(;)
  run %str(;)
  proc delete data = _last_ %str(;)
  run %str(;)
  /*+++++++++++++++++++++++++++++++++++++++++++++*/
  ));
  %end;
%mend bdeleteMacArray;
