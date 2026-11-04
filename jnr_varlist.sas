%macro jnr_varlist(
    libname=jenhelp
   ,memname=class
   ,function=  /*--- many functions possible like lowcase or quote ---*/
   ,od=" "
   ,prx="/(?!)/"  /*-- "/^/" always match '/(?!)/' never match ---*/
   ,keep=_all_
   ,drop=
 ) / des="Populate global VARLIST matching column names";

/*---

IMPORTANT (ORDER OF FILTER)

Prxmatch filter comes first then keep then drop

Cases

1 Age Height Name Sex Weight
  %put %getvars(libname=jenhelp,memname=class);

2 Height Name Weight
  %put %getvars(keep=name height weight);

3 Height Sex Weight
  %put %getvars(keep=name sex height weight,drop=name,prx="/weight/i");

4 "Name" "Sex" "Age" "Weight"
  %put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=quote,prx="/weight/i");

5 name,sex,age,weight *** function lowcase ***
  %put %jnr_varlist(libname=sashelp,memname=class,keep=name age sex,function=lowcase,prx='/weight/i',od=",");

---*/

%global varlist;
%let varlist=;

%dosubl('
data __keepdrop__;
    set &libname..&memname(keep=&keep);
    drop &drop;
    stop;
run;
proc print data=__keepdrop__;
run;
');


%dosubl('
proc sql;
  select &function(name) into :varlist separated by &od
  from
  ( select name,varnum
    from sashelp.vcolumn
    where upcase(libname) = upcase("&libname")
    and upcase(memname) = upcase("&memname")
    and prxmatch(&prx, name) > 0
    union corr
    select name, varnum
    from sashelp.vcolumn
    where upcase(libname) = upcase("work")
    and upcase(memname) = upcase("__keepdrop__")
  )
  order by varnum
;quit;');

%put NOTE: &=varlist;

&varlist

%mend jnr_varlist;
