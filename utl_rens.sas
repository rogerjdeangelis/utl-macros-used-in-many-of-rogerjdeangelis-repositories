   %macro utl_rens(dsn)/des="use with R SASXport for long variable names";

  if _n_=0 then do;

    rc=%sysfunc(dosubl('
        data __ren001;
           set &dsn(obs=1);
        run;quit;
        proc transpose data=__ren001 out=__ren002(drop=col1);
          var _all_;
        run;quit;
        proc sql;
          select
            catx(" ",_name_,"as",translate(lbl,"_",".")) into :rens separated by ","
          from
            (
             select
                _name_
               ,case
                    when (_label_ = " ") then _name_
                    else substr(_label_,1,32)
                end as lbl
             from
                __ren002
            )
       ;quit;
        proc sql;
           create
               view %scan(&dsn,2,".")  as
           select
               &rens
           from
               &dsn.
        ;quit;
    '));
    drop rc;
  end;

%mend utl_rens;

