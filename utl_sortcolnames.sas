%macro utl_sortcolnames(dsn)
  / des="sort column names aphabetically";
 %dosubl(%nrstr(
  %array(vars,values=%utl_varlist(have));
  data havPre;
    array vars[&varsn] $32 v1-v&varsn
      (%do_over(vars,phrase="?",between=comma));
    call sortc(of vars[*]);
    call symputx("lst",catx(" ",of vars[*]));
  run;quit;
  ))
%mend utl_sortcolnames;
