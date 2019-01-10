%macro utl_rptRen(nrm,acx);
%let nams=;
%let rc=
 %sysfunc(dosubl('
   %symdel nams / nowarn;
   proc sql;
     select cats("_C",put(monotonic()+1,1.),"_ =_",lon) into :nams separated by " "
     from
      (select distinct &acx as lon length=5 from &nrm)
   ;quit;
   '));
   &nams
%mend utl_rptRen;

