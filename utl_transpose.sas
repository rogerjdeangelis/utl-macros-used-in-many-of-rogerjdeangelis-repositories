%macro utl_transpose(libname_in=,
                 libname_out=,
                 data=,
                 out=,
                 by=,
                 prefix=,
                 var=,
                 autovars=,
                 id=,
                 descendingid=,
                 var_first=YES,
                 format=,
                 delimiter=,
                 copy=,
                 drop=,
                 sort=,
                 sort_options=,
                 use_varname=YES,
                 suffix=,
                 preloadfmt=,
                 guessingrows=,
                 newid=,
                 convertid=NO);
/*Check whether the data and out parameters contain one or two-level filenames*/
/*and, if needed, separate libname and data from data set options */
  %let lp=%sysfunc(findc(%superq(data),%str(%()));
  %put 1111 &=lp;
  %if &lp. %then %do;
   %let rp=%sysfunc(findc(%superq(data),%str(%)),b));
   %put 2222 &=rp;
/*for SAS
   %let dsoptions=%qsysfunc(substrn(%nrstr(%superq(data)),&lp+1,&rp-&lp-1));
   %let data=%sysfunc(substrn(%nrstr(%superq(data)),1,%eval(&lp-1)));
*/
/*for WPS*/
     %let dsoptions=%qsysfunc(substrn(%nrquote(%superq(data)),&lp+1,&rp-&lp-1)); 
     %put 3333 &=dsoptions;
     %let data=%sysfunc(substrn(%nrquote(%superq(data)),1,%eval(&lp-1))); 
     %put 4444 &=data
  %end;
  %else %let dsoptions=;
  %put 5555 &=dsoptions;
  %if %sysfunc(countw(&data.)) eq 2 %then %do;
    %let libname_in=%scan(&data.,1);
    %let data=%scan(&data.,2);
    %put &=data;
  %end;
  %else %if %length(&libname_in.) eq 0 %then %do;
    %let libname_in=work;
  %end;
  %if %sysfunc(countw(&out.)) eq 2 %then %do;
    %let libname_out=%scan(&out.,1);
    %let out=%scan(&out.,2);
  %end;
  %else %if %length(&libname_out.) eq 0 %then %do;
    %let libname_out=work;
  %end;
  %if %length(&newid.) eq 0 %then %do;
    %let newid=row;
  %end;
  /*obtain last by variable*/
  %if %length(&by.) gt 0 %then %do;
    %let lastby=%scan(&by.,-1);
  %end;
  %else %do;
    %let lastby=;
  %end;
/*Create macro variable to contain a list of variables to be copied*/
 %let to_copy=;
  %if %length(&copy.) gt 0 %then %do;
    data t_e_m_p;
      set &libname_in..&data. (obs=1 keep=&copy.);
    run;
    proc sql noprint;
      select name
        into :to_copy separated by " "
          from dictionary.columns
            where libname="WORK" and
                  memname="T_E_M_P"
        ;
      quit;
  %end;
/*Populate var parameter in the event it has a null value*/
  %if %length(&var.) eq 0 %then %do;
    data t_e_m_p;
      set &libname_in..&data. (%unquote(&dsoptions.) obs=1 drop=&by. &id. &copy.);
    run;
    proc sql noprint;
      select name
        into :var separated by " "
          from dictionary.columns
            where libname="WORK" and
                  memname="T_E_M_P"
        %if %sysfunc(upcase("&autovars.")) eq "CHAR" %then %do;
                  and type="char"
        %end;
        %else %if %sysfunc(upcase("&autovars.")) ne "ALL" %then %do;
                  and type="num"
        %end;
        ;
      quit;
  %end;
/*Initialize macro variables*/
  %let vars_char=;
  %let varlist_char=;
  %let vars_num=;
  %let varlist_num=;
  %let formats_char=;
  %let format_char=;
  %let formats_num=;
  %let format_num=;
  %let label_num=;
  %let label_char=;
  %let length_num=;
  %let length_char=;
  %let labels_num=;
  %let labels_char=;
  %let lengths_num=;
  %let lengths_char=;
/*Create file t_e_m_p to contain one record with all var variables*/
  data t_e_m_p;
    set &libname_in..&data. (obs=1 keep=&var.);
  run;
/*Create macro variables containing untransposed var names and formats*/
  proc sql noprint;
    select name, case
                   when missing(format) then " $"||strip(put(length,5.))||'.'
                   else strip(format)
                 end,
                 case
                   when missing(label) then strip(name)
                   else strip(label)
                 end,
                 " $"||strip(put(length,5.))
      into :vars_char separated by " ",
           :formats_char separated by "~",
           :labels_char separated by "~",
           :lengths_char separated by "~"
        from dictionary.columns
          where libname="WORK" and
                memname="T_E_M_P" and
                type="char"
    ;
    select name, case
                   when missing(format) then "best12."
                   else strip(format)
                 end,
                 case
                   when missing(label) then strip(name)
                   else strip(label)
                 end,
                 " "||strip(put(length,5.))
      into :vars_num separated by " ",
           :formats_num separated by "~",
           :labels_num separated by "~",
           :lengths_num separated by "~"
        from dictionary.columns
          where libname="WORK" and
                memname="T_E_M_P" and
                type="num"
    ;
    select name
      into :vars_all separated by " "
        from dictionary.columns
          where libname="WORK" and
                memname="T_E_M_P"
    ;
  quit;
/* If ID variable contains non-SAS name characters, translate them to '_' */
  %if %sysfunc(upcase("&convertid.")) eq "YES" %then %do;
    data t_e_m_p;
      set &libname_in..&data.;
      do _n_=1 to length(&id.);
        if notalnum(substr(&id.,_n_,1)) then substr(&id.,_n_,1)='_';
      end;
    run;
    %let data=t_e_m_p;
    %let libname_in=work;
  %end;
/*If sort parameter has a value of YES, create a sorted temporary data file*/
  %if %sysfunc(upcase("&sort.")) eq "YES" %then %do;
    %let notsorted=;
    %if %length(%unquote(&dsoptions.)) gt 2 %then %do;
      data t_e_m_p;
        set &libname_in..&data. (%unquote(&dsoptions.));
      run;
      %let data=t_e_m_p;
      %let libname_in=work;
    %end;
    proc sort data=&libname_in..&data.
                (keep=&by. &id. &vars_char. &vars_num. &to_copy.)
                 out=t_e_m_p &sort_options. noequals;
      by &by.;
    run;
    %let data=t_e_m_p;
    %let libname_in=work;
  %end;
  %else %if %length(%unquote(&dsoptions.)) gt 2 %then %do;
    data t_e_m_p;
      set &libname_in..&data. (%unquote(&dsoptions.));
    run;
    %let data=t_e_m_p;
    %let libname_in=work;
    %let notsorted=notsorted;
  %end;
  %else %do;
    %let notsorted=notsorted;
  %end;
  /*if no id parameter is present, create one from &newid.*/
  %if %length(&id.) eq 0 %then %do;
    data t_e_m_p;
      set &libname_in..&data.;
      by &by.;
      if first.&lastby then &newid.=1;
      else &newid+1;
    run;
    %let id=&newid.;
    %let data=t_e_m_p;
    %let libname_in=work;
  %end;
/*Ensure guessingrows parameter contains a value*/
  %if %length(&guessingrows.) eq 0 %then %do;
    %let guessingrows=%sysfunc(constant(EXACTINT));
  %end;
/*Ensure a format is assigned to an id variable*/
  %if %length(&id.) gt 0 %then %do;
    proc sql noprint;
      select type,length,%sysfunc(strip(format))
        into :tr_macro_type, :tr_macro_len, :tr_macro_format
          from dictionary.columns
            where libname="%sysfunc(upcase(&libname_in.))" and
                  memname="%sysfunc(upcase(&data.))" and
                  upcase(name)="%sysfunc(upcase(&id.))"
        ;
    quit;
    %if %length(&format.) eq 0 %then %do;
      %let optsave=%sysfunc(getoption(missing),$quote.);
      options missing=.;
      %if %length(&tr_macro_format.) gt 0 %then %do;
        %let format=&tr_macro_format.;
      %end;
      %else %if "&tr_macro_type." eq "num " %then %do;
        %let format=%sysfunc(catt(best,&tr_macro_len.,%str(.)));
      %end;
      %else %do;
        %let format=%sysfunc(catt($,&tr_macro_len.,%str(.)));
      %end;
      options missing=&optsave;
    %end;
  %end;
/*Create macro variables containing ordered lists of the requested transposed variable
  names for character (varlist_char) and numeric (varlist_num) var variables */
  %if %length(&preloadfmt.) gt 0 %then %do;
    %if %sysfunc(countw(&preloadfmt.)) eq 1 %then %do;
      %let preloadfmt=&libname_in..&preloadfmt.;
    %end;
  %end;
  %else %do;
    proc freq data=&libname_in..&data. (obs=&guessingrows. keep=&id.) noprint;
      tables &id./out=_for_format (keep=&id.);
    run;
    %if %sysfunc(upcase("&descendingid.")) eq "YES" %then %do;
      proc sort data=_for_format;
        by descending &id;
      run;
    %end;
    data _for_format;
      set _for_format;
      order=_n_;
    run;
  %end;
  proc sql noprint;
  %do i=1 %to 2;
    %if &i. eq 1 %then %let i_type=char;
    %else %let i_type=num;
    %if %length(&&vars_&i_type.) gt 0 %then %do;
    select distinct
      %do j=1 %to 4;
        %if &j. eq 1 %then %let j_type=;
        %else %if &j. eq 2 %then %let j_type=label;
        %else  %if &j. eq 3 %then %let j_type=length;
        %else %let j_type=format;
        %do k=1 %to %sysfunc(countw(&&vars_&i_type.));
         "&j_type. "||cats("&prefix.",
          %if %sysfunc(upcase("&var_first.")) eq "NO" %then %do;
            put(&id.,&format),"&delimiter."
            %if %sysfunc(upcase("&use_varname.")) ne "NO" %then
            ,scan("&&vars_&i_type.",&k.);
            ,"&suffix."
          %end;
          %else %do;
            %if %sysfunc(upcase("&use_varname.")) ne "NO" %then
               scan("&&vars_&i_type.",&k.),;
            "&delimiter.",put(&id.,&format),"&suffix."
          %end;
          )
          %if &j. eq 2 %then
            ||cats("=",scan("&&labels_&i_type.",&k.,"~"),";");
          %else %if &j. eq 3 %then
            ||" "||cats(scan("&&lengths_&i_type.",&k.,"~"),";");
          %else %if &j. eq 4 %then
            ||" "||cats(scan("&&formats_&i_type.",&k.,"~"),";");
          %if &k. lt %sysfunc(countw(&&vars_&i_type.)) %then ||;
          %else ,;
        %end;
      %end;
      %if "&tr_macro_type." eq "num " %then &id. format=best12.;
        %else &id.;
        ,order
          into :varlist_&i_type. separated by " ",
               :label_&i_type. separated by " ",
               :length_&i_type. separated by " ",
               :format_&i_type. separated by " ",
               :idlist separated by " ",
               :idorder separated by " "
           %if %length(&preloadfmt.) gt 0 %then from &preloadfmt.;
           %else from _for_format;
               order by order
    ;
      %let num_numlabels=&sqlobs.;
    %end;
  %end;
  quit;
  proc sql noprint;
    select distinct
        %let j_type=;
        %do k=1 %to %sysfunc(countw(&&vars_all.));
      "&j_type. "||cats("&prefix.",
          %if %sysfunc(upcase("&var_first.")) eq "NO" %then %do;
          put(&id.,&format),"&delimiter.",
            %if %sysfunc(upcase("&use_varname.")) ne "NO" %then
          scan("&&vars_all.",&k.);
          ,"&suffix.")
          %end;
          %else %do;
            %if %sysfunc(upcase("&use_varname.")) ne "NO" %then
          scan("&&vars_all.",&k.),;
          "&delimiter.",put(&id.,&format),"&suffix.")
          %end;
          %if &k. lt %sysfunc(countw(&&vars_all.)) %then ||;
          %else ,;
        %end;
        order
          into :varlist_all separated by " ",
               :idorder separated by " "
           %if %length(&preloadfmt.) gt 0 %then from &preloadfmt.;
           %else from _for_format;
               order by order
    ;
  quit;
/*Create a format that will be used to assign values to the transposed variables*/
  data _for_format;
    %if %length(&preloadfmt.) gt 0 %then set &preloadfmt. (rename=(&id.=start));
    %else set _for_format  (rename=(&id.=start));
    ;
    %if "&tr_macro_type." eq "num " %then retain fmtname "labelfmt" type "N";
    %else retain fmtname "$labelfmt" type "C";
    ;
    label=
     %if %length(&preloadfmt.) eq 0 %then _n_-1;
     %else order-1;
     ;
  run;
  proc format cntlin = _for_format;
  run ;
/*Create and run the datastep that does the transposition*/
   data &libname_out..&out.;
     set &libname_in..&data. (keep=&by. &id.
       %do i=1 %to %sysfunc(countw("&vars_char."));
         %scan(&vars_char.,&i.)
       %end;
       %do i=1 %to %sysfunc(countw("&vars_num."));
         %scan(&vars_num.,&i.)
       %end;
       %do i=1 %to %sysfunc(countw("&to_copy."));
         %scan(&to_copy.,&i.)
       %end;
/*       %unquote(&dsoptions.) */
       );
    by &by. &notsorted.;
    &format_char. &format_num. &label_char. &label_num. &length_char. &length_num.
  %if %length(&vars_char.) gt 0 %then %do;
    array want_char(*) $
    %do i=1 %to %eval(&num_numlabels.*%sysfunc(countw("&vars_char.")));
      %scan(&varlist_char.,&i.)
    %end;
    ;
    array have_char(*) $ &vars_char.;
    retain want_char;
    if first.&lastby. then call missing(of want_char(*));
    ___nchar=put(&id.,labelfmt.)*dim(have_char);
    do ___i=1 to dim(have_char);
      want_char(___nchar+___i)=have_char(___i);
    end;
  %end;
  %if %length(&vars_num.) gt 0 %then %do;
    array want_num(*)
    %do i=1 %to %eval(&num_numlabels.*%sysfunc(countw("&vars_num.")));
      %scan(&varlist_num.,&i.)
    %end;
    ;
    array have_num(*) &vars_num.;
    retain want_num;
    if first.&lastby. then call missing(of want_num(*));
    ___nnum=put(&id.,labelfmt.)*dim(have_num);
    do ___i=1 to dim(have_num);
      want_num(___nnum+___i)=have_num(___i);
    end;
  %end;
    drop &id. ___: &var. &drop.;
    if last.&lastby. then output;
  run;
  data &libname_out..&out.;
    retain &by. &to_copy. &varlist_all.;
    set &libname_out..&out.;
  run;
/*Delete all temporary files*/
  proc delete data=work.t_e_m_p /*work._for_format*/;
  run;
%mend utl_transpose;
