%macro utl_attrTemplate(dsns);
%dosubl(%nrstr(
  %array(_ds,values=&dsns);
  proc sql;
    create
      table _template_ as
    %do_over(_ds
     ,phrase=%str(
    select
      *
    from
      ?(obs=0))
   ,between=union all)
  ;quit;
  ))
  _template_
%mend utl_attrTemplate;
