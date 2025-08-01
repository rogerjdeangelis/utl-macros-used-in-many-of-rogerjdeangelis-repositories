%macro utl_getary(dsn);
%symdel ary/nowarn;
%dosubl('
%symdel ary/nowarn;
data _null_;
  set &dsn end=eof;
  array vars[*] _numeric_;
  length allvals $32756;
  length array_str $32756;
  length prefix $44;
  retain allvals;
  length temp $32;
  do i = 1 to dim(vars);
    temp = strip(put(vars[i], best32.));
    if missing(allvals) then allvals = temp;
    else allvals = catx(",", allvals, temp);
  end;
  if eof then do;
    r = _n_;
    c = dim(vars);
    prefix = cats("[",r,",",c,"] (");
    suffix = ");";
    array_str = catx(" ",prefix,allvals,suffix);
    put array_str=;
    call symputx("ary",array_str);
  end;
run;quit;
')
&ary
%mend utl_getary;
