%macro sqlpartition(dsn=,by=team,minus=1,order=) /
   des="Improved sqlpartition that maintains data order";
 %local res;
 %put %sysfunc(ifc(%sysevalf(%superq(dsn )=,boolean),**** Please provide input dataset  ****,));
 %put %sysfunc(ifc(%sysevalf(%superq(by  )=,boolean),**** Please provide by variables ****,));
 %let res= %eval
 (
     %sysfunc(ifc(%sysevalf(%superq(dsn )=,boolean),1,0))
   + %sysfunc(ifc(%sysevalf(%superq(by )=,boolean),1,0))
 );
  %if &res = 0 %then %do;
     %if "&order" ^= "" %then %do;
       %let order=%str(,&order);
     %end;
     (select
       *
      ,seq-min(seq) + 1 as partition
     from
        %dosubl('
           proc sql;
            create
              table _have_ as
            select
              *
           from
              &dsn
           order
            by &by &order
     ;quit;' )
     (select
        *
        ,&minus*monotonic() as seq
     from
         _have_)
     group
        by &by)
  %end;
%mend sqlpartition;
