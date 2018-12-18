%MACRO utl_aLIST_(ds = sashelp.class, prx = /ag|he/i);
  /*
     Macro to create list of variable names that satisfy a regular expression
     macro by
     Bartosz Jablonski
     yabwon@gmail.com
  */
  proc transpose
    data = &ds.(obs = 0)
    out = _TMP_(keep = _name_ where = ( PRXMATCH(%tslit(&prx.), _name_) ))
  ;
    var _all_;
  run;
  %global list;
  proc sql noprint;
    select _name_
    into :list separated by ' '
    from _tmp_;
  quit;

/*
Application
options mprint symbolgen;
%let ds = sashelp.class;
%let prx = /ag|he/i;
data want;
  set &ds.(
      %let rc = %sysfunc(dosubl('%utl_aLIST_(ds=&ds., prx=&prx.)'));
      drop = &list.
      );
run;
*/
%MEND utl_aLIST_;
