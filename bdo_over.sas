
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
  Ted Clay'a and David Katz's macro %do_over() 
*/

/* 
filename f URL "http://www.mini.pw.edu.pl/~bjablons/SASpublic/array.sas";
%include f / source2;
filename f URL "http://www.mini.pw.edu.pl/~bjablons/SASpublic/deletemacarray.sas";
%include f / source2;
*/

/*
%DO_OVER() macro uses advantage of macarray=Y parameter of %ARRAY() macro
Parameters:
  array - required, indicates a macroarray which's metadata (Lbound, Hbouns)
          will be used to loop in %DO_OVER()
  phrase - a statement to be called in each iteration of inner loop
           loop's iterator is _I_, if you want to use _I_ or array's 
           name [e.g. %myArr(&_I_.)] enclose it in %NRSTR() function
  between - a statement to be called in between each iteration of inner loop
*/

%macro bdo_over(array, phrase=%nrstr(%&array(&_I_.)), between=%str( ));
%local _I_;
%do _I_ = &&&array.LBOUND %to &&&array.HBOUND;
%if &_I_. NE &&&array.LBOUND %then 
%do;&between.%end;%unquote(%unquote(&phrase.))
%end;
%mend bdo_over;

/*

data test;
set sashelp.class;
%array(beta[*] j k l m (101 102 103 104), vnames=Y, macarray=Y)
a1 = "%beta(1)";
a2 = "%beta(2)";
a3 = "%beta(3)";
a4 = "%beta(4)";
run;


%put #%do_over(beta)#;

%put #%do_over(beta, phrase=%nrstr("%beta(&_I_.)"), between=%str(,))#;

data test1;
set sashelp.class;
%array(beta[*] j k l m (101 102 103 104), vnames=Y, macarray=Y)
%do_over(beta, phrase=%nrstr(a&_I_. = "%beta(&_I_.)";))
run;



%array(alpha[*] j k l m n, vnames=Y, macarray=Y)
%array( beta[5] $ , function = "a", macarray=Y)
%array(gamma[4] (101 102 103 104),  macarray=Y)
%put _USER_;




data test2;
  call streaminit(123);
  %do_over(beta
         , phrase = %nrstr(%beta(&_I_.) = %gamma(&_I_.) * rand('Uniform'); output;) 
         , between = put _all_;
          );
  put _all_;
run;



%do_over(beta
, phrase = %nrstr( 
    data %unquote(%alpha(&_I_.))0;  
     call streaminit(123); 
     %unquote(%beta(&_I_.))x = %gamma(&_I_.) * rand('Uniform');  
     output; 
    run; 
)
);


%macro doit(ds,var=a,val=1);

data &ds.; 
 call streaminit(123);
 &var. = &val. * rand('Uniform'); 
 output;
run;

%mend doit;

%do_over(beta
  , phrase = %nrstr( 
    %DOIT(%alpha(&_I_.)1, var = %beta(&_I_.), val = %gamma(&_I_.))
    )
);


%do_over(beta
, phrase = %nrstr( 
    data %alpha(&_I_.)2;  
     call streaminit(123); 
     %beta(&_I_.)x = %gamma(&_I_.) * rand('Uniform');  
     output; 
    run; 
)
);
*/





%macro do_over2(
  arrayI, 
  arrayJ, 
  phrase=%nrstr(%&arrayI(&_I_.) %&arrayJ(&_J_.)), 
  between=%str( )
);
  %local _I_ _J_;
  %do _I_ = &&&arrayI.LBOUND %to &&&arrayI.HBOUND;
    %do _J_ = &&&arrayJ.LBOUND %to &&&arrayJ.HBOUND;
    %if not (
            &_I_. = &&&arrayI.LBOUND 
        AND &_J_. = &&&arrayJ.LBOUND
        ) 
    %then %do;&between.%end;%unquote(%unquote(&phrase.))
    %end;
  %end;
%mend do_over2;

/*
%put *%do_over2(alpha, gamma
, phrase = %NRSTR((%alpha(&_I_.), %gamma(&_J_)))
)*;

data _NULL_;
  call symputx("CRLF", byte(13)||byte(10), "G");
run;

%put *%do_over2(alpha, gamma
, phrase = %NRSTR((%alpha(&_I_.), %gamma(&_J_)))
, between=%superq(CRLF)
)*;

%do_over2(alpha, gamma
, phrase = %NRSTR(%put (%alpha(&_I_.), %gamma(&_J_));)
)
*/


%macro do_over3(
  arrayI, 
  arrayJ, 
  arrayK, 
  phrase=%nrstr(%&arrayI(&_I_.) %&arrayJ(&_J_.) %&arrayK(&_K_.)), 
  between=%str( )
);
  %local _I_ _J_ _K_;
  %do _I_ = &&&arrayI.LBOUND %to &&&arrayI.HBOUND;
    %do _J_ = &&&arrayJ.LBOUND %to &&&arrayJ.HBOUND;
      %do _K_ = &&&arrayK.LBOUND %to &&&arrayK.HBOUND;
      %if not (
              &_I_. = &&&arrayI.LBOUND 
          AND &_J_. = &&&arrayJ.LBOUND
          AND &_K_. = &&&arrayK.LBOUND
          ) 
      %then %do;&between.%end;%unquote(%unquote(&phrase.))
      %end;
    %end;
  %end;
%mend do_over3;

/*
%array(a1_[2] (0 1), macarray=Y)
%array(a2_[2] (2 3), macarray=Y)
%array(a3_[2] (4 5), macarray=Y)

%do_over3(a1_, a2_, a3_
, phrase = %NRSTR(%put (%a1_(&_I_.), %a2_(&_J_), %a3_(&_K_));)
)

%do_over3(a1_, a1_, a1_
, phrase = %NRSTR(%put (%a1_(&_I_.), %a1_(&_J_), %a1_(&_K_));)
)
*/

/*
%macro do_over4(
  arrayI1, 
  arrayI2, 
  arrayI3, 
  arrayI4,
  phrase=%nrstr(
%&arrayI1(&_I1_.)
%&arrayI2(&_I2_.)
%&arrayI3(&_I3_.)
%&arrayI3(&_I4_.)
), 
  between=%str( )
);
  %local _I1_ _I2_ _I3_ _I4_;
  %do _I1_ = &&&arrayI1.LBOUND %to &&&arrayI1.HBOUND;
  %do _I2_ = &&&arrayI2.LBOUND %to &&&arrayI2.HBOUND;
  %do _I3_ = &&&arrayI3.LBOUND %to &&&arrayI3.HBOUND;
  %do _I4_ = &&&arrayI4.LBOUND %to &&&arrayI4.HBOUND;
  %if not (
        &_I1_. = &&&arrayI1.LBOUND 
    AND &_I2_. = &&&arrayI2.LBOUND
    AND &_I3_. = &&&arrayI3.LBOUND
    AND &_I4_. = &&&arrayI4.LBOUND
    ) 
  %then %do;&between.%end;%unquote(%unquote(&phrase.))
  %end;
  %end;
  %end;
  %end;
%mend do_over4;
*/


%macro make_do_over(size);
%if &size. > 3 %then
%do;
filename T TEMP lrecl=512;
data _null_;
file T;
length text $ 256 and $ 4;
put '%macro do_over' "&size." '(';
do i = 1 to &size.;
  text = cats('arrayI', i, ',');
  /* arrayI1, */ 
  put text;
end;
put '  phrase=%nrstr(';
do i = 1 to &size.;
  text = cats('%&arrayI', i, '(&_I', i, '_.)'); 
  /* %&arrayI1(&_I1_.) */
  put text;
end;
put '),'; 
put '  between=%str( )';
put ');';
put '  %local ';
do i = 1 to &size.;
  text = cats('_I', i, '_');
  /* _I1_ */ 
  put text;
end;
put ';';
do i = 1 to &size.;
  text = cats('%do _I', i, '_ = &&&arrayI', i, '.LBOUND %to &&&arrayI', i, '.HBOUND;');
  /* %do _I1_ = &&&arrayI1.LBOUND %to &&&arrayI1.HBOUND; */ 
  put text;
end;
put '  %if not (';

do i = 1 to &size.;
  text = cats('&_I', i, '_. = &&&arrayI', i, '.LBOUND');
  and = ifc(i = 1, "    ", "AND ");
  /* <AND> &_I1_. = &&&arrayI1.LBOUND */ 
  put and text;
end;
put '    )';
put '  %then %do;&between.%end;%unquote(%unquote(&phrase.))';
do i = 1 to &size.;
  put '%end;';
end;
put '%mend;';
run;
%include T; /* / source2;*/
filename T;
%end;
%else
%do;
 %put NOTE:[&sysmacroname.] NO MACRO GENERATED FOR SIZE = &size.;
 %put NOTE-[&sysmacroname.] SIZE must be greather than 3!!!;
%end;
%mend make_do_over;

data _null_; run;
/*
%make_do_over(1);
%make_do_over(2);
%make_do_over(3);
*/
%make_do_over(4);

/*
%do_over4(a1_, a1_, a1_, a1_
, phrase = %NRSTR(%put (%a1_(&_I1_.), %a1_(&_I2_), %a1_(&_I3_), %a1_(&_I4_));)
)

%put *%do_over4(a1_, a1_, a1_, a1_
, between = *
)*
;
*/

%make_do_over(5);

/*
%do_over5(a1_, a1_, a1_, a1_, a1_
, phrase = %NRSTR(%put (%a1_(&_I1_.), %a1_(&_I2_), %a1_(&_I3_), %a1_(&_I4_), %a1_(&_I5_));)
)

%put *%do_over5(a1_, a1_, a1_, a1_, a1_
, between = *
)*
;

options nomprint;
data test2;
%do_over5(a1_, a1_, a1_, a1_, a1_
, phrase = %NRSTR(x1 = %a1_(&_I1_.); x2 = %a1_(&_I2_); x3 = %a1_(&_I3_); x4 = %a1_(&_I4_);  x5 = %a1_(&_I5_);)
, between = output;
)
output;
run;
*/

/*
%array(loop[6:10] (6:10), macarray=Y)
%do_over(loop
  , phrase = %nrstr( 
    %make_do_over(%loop(&_I_.))
    )
);
*/

