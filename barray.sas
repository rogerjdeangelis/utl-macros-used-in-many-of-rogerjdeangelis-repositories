
/**###################################################################**/
/*                                                                     */
/*  Copyright Bartosz Jablonski, January 2019.                         */
/*                                                                     */
/*  Code is free and open source. If you want - you can use it.        */
/*  But it comes with absolutely no warranty whatsoever.               */
/*  If you cause any damage or something - it will be your own fault.  */
/*  You've been warned! You are using it on your own risk.             */
/*  However, if you decide to use it don't forget to mention author.   */
/*  Bartosz Jablonski (yabwon@gmail.com)                               */
/*                                                                     */
/**###################################################################**/

/*
  the code of below macro was inspired by 
  Ted Clay'a and David Katz's macro %array() 
*/

/*
options nomprint nosymbolgen nomlogic;
*/

%macro barray(
/*
ARGUMENT:     DESCRIPTION:
*/
array,     /* declaration/definition of an array, e.g. 'myArr[*] x1-x3 (4:6)' or 'myBrr[*] $ y1-y3 ("a" "b" "c")'
              or 'myCrr[3] $ ("d d d" "e,e,e" "f;f;f")' or 'myDrr p q r s' 
              if array's name is _ (single underscore) then attached variables list's names are used, a call of 
              the form %array(_[*] p1 q2 r3 s4 (-1 -2 -3 -4)) will create macrovariables: p1,q2,r3, and s4 with 
              respective values: -1,-2,-3, and -4 
              tree additional global macrovariables myArrLBOUND, myArrHBOUND, and myArrN are generated with the 
              macroarray - more examples are attached below
            */
function=, /* optional, function/expression to be applayed to all array's cells, _I_ is as araay's iterator 
            */
before=,   /* optional, function/expression to be added before looping through array, e.g. call streaminit(123) 
            */
after=,    /* optional, function/expression to be added after looping through array, e.g. call sortn(ABC) 
            */
vnames=N,  /* default=N, if set to Y/YES then macroarray is builded based on variables names instead values, 
              e.g. call to %array(myArr[*] x1-x3 (4:6), vnames=Y) will use x1 x2 x3 instead 4 5 6 as values 
            */
macarray=N,/* default=N, if set to Y/YES then macro named array's name is compiled to create convinient envelope 
              for multiple ampersands, e.g. call to %array(myArr[*] x1-x3 (4:6), macarray=Y) will create 
              %myArr(J) macro which will allow to extract "data" from macroarray like: %let x = %myArr(1); 
              or when used with parameter M=I allow to overwrite macroarrays value: %let %myArr(17,M=I) = 42;
            */ 
ds=,       /* use a dataset as a basis for macroarray's data, if used by default overwrites use of 'array' parameter,
              honors macarray= argument usage, dataset options are allowed, e.g. sashelp.class(obs=5) 
            */
vars=      /* list of variables used to create macroarrays from a dataset, list format can be as follows:
              variable1<delimiter><arrayname1> variable2<delimiter><arrayname2> ... variableN<delimiter><arraynameN>
              (<...> means optional), delimiters are hash(#) and pipe(|), currently only space is supported as separator
              meaning of # and | delimiters will be explained in the following example: 
              if vars = height#h weight weight|w age|
               then following macroarrays will be created:
                1) marray "H" with ALL(#) values of variable "height"
                2) marray "WEIGHT" with ALL(noseparator is equivalent to #) values of variable "weight"
                3) marray "W" with UNIQUE(|) values of variable "weigth"
                4) marray "AGE" with UNIQUE(|) values of variable "age"
            */
);
%local array function before macarray ds vars
       name _BEFORE_ _F_ _FBY_ _AFTER_ rc mtext
       _ALL_MACROVARIABLES_CREATED_;

%if %bquote(&ds.)   ne %then %goto FromDataset;
%if %bquote(&array.) = %then %goto Exit;

/* CREATE ARRARY FROM STATEMENT */
/* extract an array name */
%let name = %unquote( %qscan( &array., 1, %str([{( )}]) ) );
/* %put **&=array.**; */
/* %put **&=name.**; */

/* temp macrovariable */
%let mtext = _%sysfunc(int(%sysevalf(1000000 * %sysfunc(rand(uniform)))))_;

/* you can insert a function() into array */
%if %bquote(&function.) ne %then
  %do;
    %let _F_ = &name.[_I_] = %superq(function) ;
    %let _FBY_ = 1;
  %end;
%else 
  %do;
    %let _F_ =;
    %let _FBY_ = -1;
  %end;

/* sometimes function needs e.g. call streaminit() */
%if %bquote(&before.) ne %then %let _BEFORE_ = %superq(before);
                         %else %let _BEFORE_ =;
/* sometimes array needs e.g. call sortn() */
%if %bquote(&after.) ne  %then %let _AFTER_ = %superq(after);
                         %else %let _AFTER_ =;
%let rc = %sysfunc(
dosubl(
/*===============================================================================================*/
options nonotes nosource %str(;)
DATA _NULL_ %str(;)
 ARRAY %superq(array) %str(;) /* here the array is created */

 /* if range starts < 0 the it is shiftrd to 0 */
 _IORC_ = IFN(LBOUND(&name.) < 0, -LBOUND(&name.), 0) %str(;)

 %unquote(&_BEFORE_.) %str(;)

 DO _I_ = LBOUND(&name.) TO HBOUND(&name.) BY &_FBY_. %str(;)
   %unquote(&_F_.) %str(;) /* place for a function to be applayed */
 END %str(;)

 %unquote(&_AFTER_.) %str(;)

 DO _I_ = LBOUND(&name.) TO HBOUND(&name.) %str(;)
   SELECT %str(;)
      WHEN ("&name." = "_") /* if array name is _ then use variables names instead as names */
        CALL SYMPUTX(VNAME(&name.[_I_]), &name.[_I_], 'G') %str(;)
      WHEN ("%qupcase(&vnames.)" in ("Y" "YES")) /* use variables names as values */
        CALL SYMPUTX(CATS("&name.", put(_I_+_IORC_, best32.)), VNAME(&name.[_I_]), 'G') %str(;)
      OTHERWISE
        CALL SYMPUTX(CATS("&name.", put(_I_+_IORC_, best32.)), &name.[_I_], 'G') %str(;)
   END %str(;)
 END %str(;)

 CALL SYMPUTX("&name.LBOUND", LBOUND(&name.)+_IORC_, 'G') %str(;)
 CALL SYMPUTX("&name.HBOUND", HBOUND(&name.)+_IORC_, 'G') %str(;)
 CALL SYMPUTX("&name.N", HBOUND(&name.) - LBOUND(&name.) + 1, 'G') %str(;)
 CALL SYMPUTX ("_all_macrovariables_created_", HBOUND(&name.) - LBOUND(&name.) + 1, "L") %str(;)
 /* create macro which allow to call to created macroarrayarray elemrnts 
    like to regular array e.g. '%let x = %arr(17);' */
 IF NOT("&name." = "_") AND ("%qupcase(&macarray.)" in ("Y" "YES"))
 THEN
   CALL SYMPUTX("&mtext.", 
        '%MACRO ' !! "&name." !! '(J, M=O);' !! 
        '%local J M; %if %qupcase(&M.)=O %then %do;' !!
        '%if %sysevalf( (&&&sysmacroname.LBOUND LE &J.) * (&J. LE &&&sysmacroname.HBOUND) ) %then %do;&&&sysmacroname.&J.%end;' !! 
        '%else %do;' !! 
           /* put . for numeric out of range */
           IFC(not(UPCASE("&vnames.") = "Y") AND  VTYPE(&name.[LBOUND(&name.)])='N', '.', '') !!
          '%put WARNING:[Macroarray &sysmacroname.] Index &J. out of range.;' !!
          '%put WARNING-[Macroarray &sysmacroname.] Should be between &&&sysmacroname.LBOUND and &&&sysmacroname.HBOUND;' !!
          '%put WARNING-[Macroarray &sysmacroname.] Missing value is used.;' !!
        '%end;' !!
        '%end;' !!
        '%else %do; %if %qupcase(&M.)=I %then %do;' !!
        '%if %sysevalf( (&&&sysmacroname.LBOUND LE &J.) * (&J. LE &&&sysmacroname.HBOUND) ) %then %do;&sysmacroname.&J.%end;' !! 
        '%else %do;' !! 
          '%put ERROR:[Macroarray &sysmacroname.] Index &J. out of range.;' !!
          '%put ERROR-[Macroarray &sysmacroname.] Should be between &&&sysmacroname.LBOUND and &&&sysmacroname.HBOUND;' !!
        '%end;' !!
        '%end; %end;' !!
        '%MEND;', 'G') %str(;)
 ELSE
   CALL SYMPUTX("&mtext.", ' ', 'G') %str(;)
RUN %str(;)
/*===============================================================================================*/
));
&&&mtext.
%symdel &mtext. / NOWARN ;
%put NOTE:[&sysmacroname.] &_ALL_macrovariables_CREATED_. macrovariables created;
%goto Exit;

%FromDataset: 
/* CREATE ARRAY FROM DATASET */

/* let ds = sashelp.class                      */
/* if vars = height#h weight weight|w age|
   then create:
    1) marray "h" with ALL values of variable "height"
    2) marray "weight" with ALL values of variable "weight"
    3) marray "w" with UNIQUE values of variable "weigth"
    4) marray "age" with UNIQUE values of variable "age"
*/

%local numvars i toBeCalled toBeLooped toBeAfter av avNumber a v;

/* count number of variables */
%let numvars = %qsysfunc(countw(%superq(vars), %str( )));
%if not &numvars. %then %goto Exit;
/*%put &=numvars.;*/

%let toBeCalled =; /* declarations before looping through dataset */
%let toBeLooped =; /* declarations during looping through dataset */
%let toBeAfter =;  /* declarations after looping through dataset */

/* loop through all variables */
%do i = 1 %to &numvars.;
  /* select variable and check if there is differnt name for array  */
  %let av = %qscan(%superq(vars), &i., %str( )); 
  %let avNumber = %qsysfunc(countw(%superq(av), %str(#|)));
  /*%put *&=av*&=avNumber*;*/
  
  /* get variable name and array name */
  %let v = %qscan(%superq(av),          1, %str(#|));
  %let a = %qscan(%superq(av), &avNumber., %str(#|));

  /* check if unique values should be selected */
  %if %index(%superq(av), %str(|)) > 0 %then
    %do; 
      /*%put *in pipe|*&=a &=v*;*/
      %let toBeCalled 
    = %superq(toBeCalled)%str(;) 
      declare hash &v._h&i.() %str(;) 
      &v._h&i..defineKey("&v.") %str(;) 
      &v._h&i..defineData("&v.") %str(;) 
      &v._h&i..defineDone() %str(;)
      declare hiter &v._hi&i.("&v._h&i.") %str(;) 
      ;
      %let toBeLooped 
    = %superq(toBeLooped)%str(;)
      _IORC_ = &v._h&i..ADD() %str(;)
      ;
      %let toBeAfter 
    = %superq(toBeAfter)%str(;)
      CALL SYMPUTX("&a.LBOUND",                  1, 'G') %str(;)
      CALL SYMPUTX("&a.HBOUND", &v._h&i..NUM_ITEMS, 'G') %str(;)
      CALL SYMPUTX("&a.N"     , &v._h&i..NUM_ITEMS, 'G') %str(;)
      DO WHILE(&v._hi&i..NEXT()=0) %str(;)
        &v._i&i.+1%str(;) CALL SYMPUTX(CATS("&a.", put(&v._i&i., best32.)), &v., 'G') %str(;)
      END %str(;)
      CALL SYMPUTX("&a.mtext", 
        '%MACRO ' !! "&a." !! '(J,M=O);' !! 
        '%local J M; %if %qupcase(&M.)=O %then %do;' !!
        '%if %sysevalf( (&&&sysmacroname.LBOUND LE &J.) * (&J. LE &&&sysmacroname.HBOUND) ) %then %do;&&&sysmacroname.&J.%end;' !! 
        '%else %do;' !! IFC(VTYPE(&v.)='N','.','') !! /* put . for numeric out of range */
          '%put WARNING:[Macroarray &sysmacroname.] Index &J. out of range.;' !!
          '%put WARNING-[Macroarray &sysmacroname.] Should be between &&&sysmacroname.LBOUND and &&&sysmacroname.HBOUND;' !!
          '%put WARNING-[Macroarray &sysmacroname.] Missing value is used.;' !!
        '%end;' !!
        '%end;' !!
        '%else %do; %if %qupcase(&M.)=I %then %do;' !!
        '%if %sysevalf( (&&&sysmacroname.LBOUND LE &J.) * (&J. LE &&&sysmacroname.HBOUND) ) %then %do;&sysmacroname.&J.%end;' !! 
        '%else %do;' !!
          '%put ERROR:[Macroarray &sysmacroname.] Index &J. out of range.;' !!
          '%put ERROR-[Macroarray &sysmacroname.] Should be between &&&sysmacroname.LBOUND and &&&sysmacroname.HBOUND;' !!
        '%end; %end; %end;' !!
        '%MEND;', 'G') %str(;)
        _ALL_MACROVARIABLES_CREATED_ + &v._h&i..NUM_ITEMS %str(;)
      ;
    %end;
  %else
    %do;
      /*%put *in hash#*&=a &=v*;*/
      /* toBeCalled is not changed */
      /*%let toBeCalled = %superq(toBeCalled)%str(;) ;*/
      %let toBeLooped 
    = %superq(toBeLooped)%str(;) 
      &v._i&i.+1%str(;) CALL SYMPUTX(CATS("&a.", put(&v._i&i., best32.)), &v., 'G') %str(;)
      ;
      %let toBeAfter 
    = %superq(toBeAfter)%str(;)
      CALL SYMPUTX("&a.LBOUND",        1, 'G') %str(;)
      CALL SYMPUTX("&a.HBOUND", &v._i&i., 'G') %str(;)
      CALL SYMPUTX("&a.N"     , &v._i&i., 'G') %str(;)
      CALL SYMPUTX("&a.mtext", 
        '%MACRO ' !! "&a." !! '(J,M=O);' !! 
        '%local J M; %if %qupcase(&M.)=O %then %do;' !!
        '%if %sysevalf( (&&&sysmacroname.LBOUND LE &J.) * (&J. LE &&&sysmacroname.HBOUND) ) %then &&&sysmacroname.&J.;' !! 
        '%else %do;' !! IFC(VTYPE(&v.)='N','.','') !! /* put . for numeric out of range */
          '%put WARNING:[Macroarray &sysmacroname.] Index &J. out of range.;' !!
          '%put WARNING-[Macroarray &sysmacroname.] Should be between &&&sysmacroname.LBOUND and &&&sysmacroname.HBOUND;' !!
          '%put WARNING-[Macroarray &sysmacroname.] Missing value is used.;' !!
        '%end;' !!
        '%end;' !!
        '%else %do; %if %qupcase(&M.)=I %then %do;' !!
        '%if %sysevalf( (&&&sysmacroname.LBOUND LE &J.) * (&J. LE &&&sysmacroname.HBOUND) ) %then %do;&sysmacroname.&J.%end;' !! 
        '%else %do;' !!
          '%put ERROR:[Macroarray &sysmacroname.] Index &J. out of range.;' !!
          '%put ERROR-[Macroarray &sysmacroname.] Should be between &&&sysmacroname.LBOUND and &&&sysmacroname.HBOUND;' !!
        '%end; %end; %end;' !!
        '%MEND;', 'G') %str(;)
        _ALL_MACROVARIABLES_CREATED_ + &v._i&i. %str(;)
      ;
    %end;
%end;

%let rc = %sysfunc(
dosubl(
/*===============================================================================================*/
options nonotes nosource nomprint ps = min %str(;)
DATA _NULL_ %str(;)
 IF 0 THEN SET &ds. %str(;)
  
 %unquote(&toBeCalled.) %str(;)

 DO UNTIL (EOF) %str(;)
   SET &ds. END=EOF %str(;)
   %unquote(&toBeLooped.) %str(;) /* place where macroarray are created */
 END %str(;)

 %unquote(&toBeAfter.) %str(;)

 CALL SYMPUTX ("_all_macrovariables_created_", _all_macrovariables_created_, "L") %str(;)
 STOP %str(;)
RUN %str(;)
/*===============================================================================================*/
));

%do i = 1 %to &numvars.;
  /* select variable and check if there is differnt name for array  */
  %let av = %qscan(%superq(vars), &i., %str( )); 
  %let avNumber = %qsysfunc(countw(%superq(av), %str(#|)));
  /*%put *&=av*&=avNumber*;*/
  
  /* get variable name and array name */
  %let v = %qscan(%superq(av),          1, %str(#|));
  %let a = %qscan(%superq(av), &avNumber., %str(#|));
  
  /* compile macro-array */
  %if %bquote(&macarray.) = Y OR %bquote(&macarray.) = y %then
  %do;
    %unquote(&&&a.mtext)
  %end;

  %symdel %unquote(&a.mtext) / NOWARN ;
%end;
%put NOTE:[&sysmacroname.] &_ALL_macrovariables_CREATED_. macrovariables created;
%Exit:
%mend barray;



/* EXAMPLES AND USECASES */

/* 1) creating an array like "statement" */
/*

  %array(a[*] x1-x5 (1:5))
  %put _user_;

  %array(aa{*} x1-x5 (1:5))
  %put _user_;

  %array(aaa(*) x1-x5 (1:5))
  %put _user_;
  
  %array(aaaa x1-x5 (1:5))
  %put _user_;

  %array(b[5] (5*17))
  %put _user_;

  %array(c[3] $ 10 ("a A" "b,B" "c;C"))
  %put _user_;

*/

/* if range starts < 0 then it is shifted to 0 */
/* in case when range is from 1 to M then macrovariable <arrayname>N = M
   in case when fange is different the <arrayname>N returns number of 
   elements in the array (Hbound - Lbound + 1)
*/
/*

  %array(d[-2:2] $ ("a" "b" "c" "d" "e"))
  %put &=dLBOUND. &=dHBOUND. &=dN.; 
  %put &=d0. &=d1. &=d2. &=d3. &=d4.;

*/

/* it is possible to assign value of a function to cell in an array: array[_I_]=function(...); */
/* you can use an iterator in a function, as usual it is _I_ */
/*

  %array(e[-3:3] $, function = "A" ) 
  %put &=eLBOUND. &=eHBOUND. &=eN.; 
  %put &=e0. &=e1. &=e2. &=e3. &=e4. &=e5. &=e6.;

  %array(f[-3:3], function = (2**_I_) ) 
  %put &=fLBOUND. &=fHBOUND. &=fN.;
  %put _user_;

  %array(g[1:10], function = ranuni(123) )
  %put &=gLBOUND. &=gHBOUND. &=gN.;
  %put _user_;

  %array(gg[0:45] $ 11, function = put(intnx("MONTH", '1jun2018'd, _I_, "E"), yymmn.))
  %put &=ggLBOUND. &=ggHBOUND. &=ggN.;
  %put _user_;

*/

/* need setup something before? */
/*

  %array(h[1:10], function = rand('Uniform'), before = call streaminit(123) ) 
  %put _user_;

*/

/* Fibonacci series */
/*

  %array(i[1:30] (30*0), function =  ifn(_I_ < 2, 1, sum(i[max(_I_-2,1)],i[max(_I_-1,2)]) )  ) 
  %put _user_;

*/

/* Upcase Letters */
/*

  %array(UL[26] $, function = byte(rank("A")+_I_-1) )
  %put _user_;

*/

/* lowcase letters, with macroarray=Y 
   input mode is also supported with M=I [Mode = Input]
*/
/*

  %array(ll[26] $, function = byte(rank("a")+_I_-1), macarray=Y) 
  %put _user_;
  %let xxx = %ll(2);
  %put *%ll(&llLBOUND.)*&=xxx.*%ll(3)*%ll(4)*%ll(5)*...*%ll(&llHBOUND.)*;
  %put *%ll(555)*;
  
  %put *%ll(2)*;
  %let %ll(2,M=I) = bbb;
  %put *%ll(2)*;

  %let %ll(555,M=I) = bbb;
*/

/* how to use vnames=Y*/
/*

  %array(R R1978-R1982)
  %put _user_;

  %array(R R1978-R1982 (78:82))
  %put _user_;

  %array(R R1978-R1982 (78:82), vnames=Y)
  %put _user_;

  %array(R R1978-R1982, vnames=Y)
  %put _user_;

*/



/* "no name" array i.e. the _[*] array */
/*

  %array(_[*] x1-x5 (1:5))
  %put _user_;

  %array(_[*] p q r s (4*42))
  %put _user_;

*/

/* if no variables added than use _1 _2 ... _N */
/*

  %array(_[4] (-1 -2 -3 -4)) 
  %put _user_;

*/



/* since it is clear macro code it can be used in a datastep */
/*

  data test;
  set sashelp.class;
  %array(ds[*] d1-d4 (4*17))
  a1 = &ds1.;
  a2 = &ds2.;
  a3 = &ds3.;
  a4 = &ds4.;
  run;

  data test;
  set sashelp.class;
  %array(_[*] j k l m (4*17))
  a1 = &j.;
  a2 = &k.;
  a3 = &l.;
  a4 = &m.;
  run;

  data test;
  set sashelp.class;
  %array(alpha[*] j k l m (101 102 103 104), macarray=Y)
  a1 = %alpha(1);
  a2 = %alpha(2);
  a3 = %alpha(3);
  a4 = %alpha(4);
  a5 = %alpha(555);
  run;

  data test;
  set sashelp.class;
  %array(beta[*] j k l m (101 102 103 104), vnames=Y, macarray=Y)
  a1 = "%beta(1)";
  a2 = "%beta(2)";
  a3 = "%beta(3)";
  a4 = "%beta(4)";
  a5 = "%beta(555)";
  run;

  data test;
  set sashelp.class;
  %array(gamma[4] $ 12 ("101" "102" "103" "104"), macarray=Y)
  a1 = "%gamma(1)";
  a2 = "%gamma(2)";
  a3 = "%gamma(3)";
  a4 = "%gamma(4)";
  a5 = "%gamma(555)";
  run;

*/

/* 2) creating an array from a dataset                          */
/*

  %array(ds = sashelp.class, vars = height weight age)
  %put _user_;

*/

/* if vars = height#h weight weight|w age|
   then create:
    1) marray "h" with ALL(#) values of variable "height"
    2) marray "weight" with ALL(noseparator is equivalent to #) values of variable "weight"
    3) marray "w" with UNIQUE(|) values of variable "weigth"
    4) marray "age" with UNIQUE(|) values of variable "age"
   currently only separator in VARS is space
*/
/*

  %array(ds = sashelp.class, vars = height#h weight weight|w age|)
  %put _user_;

  %array(ds = sashelp.class, vars = height#h weight weight|w age|, macarray=Y)
  %put *%h(&hLBOUND.)**%h(2)**%h(&hHBOUND.)*;

*/


/* you can applay dataset options */
/*

  %array(ds = sashelp.cars(obs=100 where=(Cylinders=6)), vars = Make| Type| Model, macarray=Y)
  %put *%make(&makeLBOUND.)*%Model(2)*%Model(3)*%Model(4)*%type(&typeHBOUND.)*;

  data test;
  set sashelp.class;
  %array(ds = sashelp.cars, vars = Cylinders|, macarray=Y)
  a0 = %Cylinders(0);
  a1 = %Cylinders(1);
  a2 = %Cylinders(2);
  a3 = %Cylinders(3);
  a4 = %Cylinders(4);
  a5 = %Cylinders(555);
  run;

*/



