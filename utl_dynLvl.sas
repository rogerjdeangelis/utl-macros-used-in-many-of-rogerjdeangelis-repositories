    %macro utl_dynLvl(dsn,var)/des="get the cardinality of a variable for use in a sas array";

     %dosubl('
      proc sql noprint;
        select
          count(distinct &var)
        into
          :_sessref_
        from
          &dsn
      ;quit;
     ')

      &_sessref_

    %mend utl_dynLvl;