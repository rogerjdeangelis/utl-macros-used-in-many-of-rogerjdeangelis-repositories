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
            catx(' ',_name_,"as",compress(lbl,'.')) into :rens separated by ","
          from
            (
             select
                _name_
               ,case
                    when (_label_ = ' ') then _name_
                    else _label_
                end as lbl
             from
                __ren002
            )
       ;quit;

        proc sql;
           create
               view %scan(&dsn,2,'.')  as
           select
               &rens
           from
               &dsn.
        ;quit;
    '));
    drop rc;
  end;

%mend utl_rens;

