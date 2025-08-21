%macro utl_unqvar(dsn,var)
  / des="Return unique levels";
   %dosubl(%nrstr(
      proc sql noprint;
        select
          count(distinct &var)
        into
          :unqvar trimmed
        from
          &dsn
        ;quit;
      ))&unqvar
%mend utl_unqvar;
