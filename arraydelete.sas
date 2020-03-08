%macro arraydelete(pfx)/des="Delete array macrovariables create by array macro";
  %if %symexist(&&pfx.n) %then %do;
     %do i= 1 %to &&&pfx.n;
         %symdel &pfx&i / nowarn;
     %end;
     %symdel  &&pfx.n / nowarn;
  %end;
%mend arraydelete;
