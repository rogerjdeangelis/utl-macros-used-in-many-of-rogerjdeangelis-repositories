
%macro slc_optlenpos(
       inp          /* input dataset  */
      ,out          /* output dataset */
      ,compress=binary   /* output compression */
      )
      / des="Create and apply a length statement to optimize variable attributes";

   /*
     Changed

         name of arrays to avoid clashes with input data (aded an under score)

         array num[&num]    _numeric_    to  array _num[&num]    _numeric_
         array lennum[&num] _temporary_  to  array _lennum[&num] _temporary_

         array chr[&chr] _character_     to  array _chr[&chr] _character_
         array lenchr[&chr] _temporary_  to  array _lenchr[&chr] _temporary_
    */

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

             array _num[&num]    _numeric_  ;
             array _lennum[&num] _temporary_;

           %end;

           %if &chr ne 0 %then %do;

             array _chr[&chr] _character_;
             array _lenchr[&chr] _temporary_;

             do __i=1 to dim(_chr);
                if lengthn(_chr[__i]) > _lenchr[__i] then _lenchr[__i]=length(_chr[__i]);
             end;

           %end;

           * if you can make the numeric variable integers this will usually cut the length of numeric in half;
           * this could be made more elegant but for maintenence reasons I kept it this way;
           * Rick Langston first proposed this;
           %if &num ne 0 %then %do;

             do i=1 to dim(_num);

                if missing(_num[i]) then _len=3;
                else do;
                  if _num[i] ne trunc( _num[i], 7 ) then _len = 8 ; else
                  if _num[i] ne trunc( _num[i], 6 ) then _len = 7 ; else
                  if _num[i] ne trunc( _num[i], 5 ) then _len = 6 ; else
                  if _num[i] ne trunc( _num[i], 4 ) then _len = 5 ; else
                  if _num[i] ne trunc( _num[i], 3 ) then _len = 4 ; else _len=3;
                end;
                if _len > _lennum[i] then _lennum[i]=_len;

              end;
           %end;

           * build and execute the program to optimize attributes;
           if dne then do;
              call execute(
              "data &out(
                   compress=&compress
                   label='Dataset &inp processed by utl_optlen')
              ;");
              call execute( 'retain');
              do until (dnepos);
                 set __layout(keep=variable) end=dnepos;
                 call execute( variable);
              end;
              call execute( ';length');

              %if &chr ne 0 %then %do;
               do __i=1 to dim(_chr);
                 var=catx(' ',vname(_chr[__i]),cats('$',put(_lenchr[__i],6.)));
                 call execute( var);
               end;
              %end;

              %if &num ne 0 %then %do;
               do __i=1 to dim(_num); * do not want I variable;
                 var=catx(' ',vname(_num[__i]),put(_lennum[__i],6.));
                 call execute( var);
               end;
              %end;
              call execute( ";set &inp;format _all_;informat _all_;run;quit;");

           end;

     %end;  * end do some work;

  run;quit;


%mend slc_optlenpos;
