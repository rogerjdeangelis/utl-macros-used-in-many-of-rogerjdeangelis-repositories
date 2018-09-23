%macro utl_optlen(
       inp=          /* input dataset  */
      ,out=          /* output dataset */
      ,compress=binary   /* output compression */
      )
      / des="Create and apply a length statement to optimize variable attributes";

   %local retain num char dsid res nvars rc;

   * Input exist and/or empty;
   %let dsid  = %sysfunc(open(&inp,is));
   %let nvars = 0;
   %if &dsid ne 0 %then %do;
       %let nvars = %sysfunc(attrn(&dsid,NVARS));
   %end;

   %if &dsid ne 0 %then %do; %let rc=%sysfunc(close(&dsid)); %end;

   * Test for complete input;
   %put %sysfunc(ifc(%sysevalf(%superq(inp      )=,boolean) ,ERROR: Please Provide an Input dataset   ,));
   %put %sysfunc(ifc(%sysevalf(%superq(out      )=,boolean) ,ERROR: Please Provide an output dataset  ,));
   %put %sysfunc(ifc(%sysevalf(%superq(compress )=,boolean) ,ERROR: Please Provide compression        ,));
   %put %sysfunc(ifc(%sysevalf(%superq(dsid     )=0,boolean),ERROR: %sysfunc(sysmsg())                ,));
   %put %sysfunc(ifc(%sysevalf(%superq(nvars    )=0,boolean),ERROR: Dataset &inp is empty             ,));

    %let res= %eval
    (
        %sysfunc(ifc(%sysevalf(%superq(inp      )=,boolean),1,0))
      + %sysfunc(ifc(%sysevalf(%superq(out      )=,boolean),1,0))
      + %sysfunc(ifc(%sysevalf(%superq(compress )=,boolean),1,0))
      + %sysfunc(ifc(%sysevalf(%superq(nvars    )=0,boolean),1,0))
      + %sysfunc(ifc(%sysevalf(%superq(dsid     )=0,boolean),1,0))
    );

     %if &res = 0 %then %do; * passed;

        ods listing close;;
        ods output position=__layout;
        proc contents data=&inp position;
        run;quit;
        ods listing;

        * build retain statement;
        * use separated to eliminate leading blanks;
        proc sql noprint;
           select sum(type='Char'), sum(type='Num')
                  into :chr separated by ' ', :num  separated by ' ' from __layout;
        ;quit;

        data _null_;

           set &inp end=dne;

           %if &num ne 0 %then %do;

             array num[&num]    _numeric_  ;
             array lennum[&num] _temporary_;

           %end;

           %if &chr ne 0 %then %do;

             array chr[&chr] _character_;
             array lenchr[&chr] _temporary_;

             do __i=1 to dim(chr);
                if lengthn(chr[__i]) > lenchr[__i] then lenchr[__i]=length(chr[__i]);
             end;

           %end;

           * if you can make the numeric variable integers this will usually cut the length of numeric in half;
           * this could be made more elegant but for maintenence reasons I kept it this way;
           * Rick Langston first proposed this;
           %if &num ne 0 %then %do;

             do i=1 to dim(num);

                if missing(num[i]) then len=3;
                else do;
                  if num[i] ne trunc( num[i], 7 ) then len = 8 ; else
                  if num[i] ne trunc( num[i], 6 ) then len = 7 ; else
                  if num[i] ne trunc( num[i], 5 ) then len = 6 ; else
                  if num[i] ne trunc( num[i], 4 ) then len = 5 ; else
                  if num[i] ne trunc( num[i], 3 ) then len = 4 ; else len=3;
                end;
                if len > lennum[i] then lennum[i]=len;

              end;
           %end;

           * build and execute the program to optimize attributes;
           if dne then do;
              call execute(
              "data &out(
                   compress=&compress
                   label='Dataset &inp processed by utl_optlen, Variable lengths may have been shortened and compression changed')
              ;");
              call execute( 'retain');
              do until (dnepos);
                 set __layout(keep=variable) end=dnepos;
                 call execute( variable);
              end;
              call execute( ';length');

              %if &chr ne 0 %then %do;
               do __i=1 to dim(chr);
                 var=catx(' ',vname(chr[__i]),cats('$',put(lenchr[__i],6.)));
                 call execute( var);
               end;
              %end;

              %if &num ne 0 %then %do;
               do __i=1 to dim(num); * do not want I variable;
                 var=catx(' ',vname(num[__i]),put(lennum[__i],6.));
                 call execute( var);
               end;
              %end;
              call execute( ";set &inp;run;quit;");

           end;

     %end;  * end do some work;

  run;quit;


%mend utl_optlen;
