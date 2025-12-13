%macro utl_mdlgetpos
   (
     pos=N;
    ,inp=workx.lgs_btr
    ,bst=workx.lgs_bst
    ,out=workx.lgs_mgmmodnrm
   ) / des="List top 200 models from rsquare";

    /*
    %let pos=N;
    %let inp=workx.lgs_btr;
    %let bst=workx.lgs_bst ;
    %let out=workx.lgs_mgmmodnrm;
    */

  proc delete data= fbs_sllpos fbs_modelsrt;
  run;quit;

  %if "%upcase(%substr(&pos,1,1))" = "N" %then %do;
    data fbs_sllpos ;
       set workx.lgs_btr (drop= _model_ _type_ _depvar_ _rmse_ intercept _edf_  rename=(_rsq_=rsq _p_=p _in_=ins ));
    run;
  %end;

  %if "%upcase(%substr(&pos,1,1))" = "Y" %then %do;
   data fbs_sllpos(drop=_i_);

       set workx.lgs_btr(drop= _model_ _type_ _depvar_ _rmse_ intercept _edf_  rename=(_rsq_=rsq _p_=p _in_=ins ));
       array ind[*] _numeric_;
       if min(of ind[*])>0  ;
       set=0;
       do _i_=1 to dim(ind);
         if not missing(ind[_i_]) then set=set+1;
       end;
    run;

  %end;

  /*---
  All possible models
  Middle Observation(68314 ) of table = fbs_sllpos - Total Obs 136,629 12DEC2025:13:18:29

   -- NUMERIC --
  ins                N8               7   Number of regressors in model
  p                  N8               8   Number of parameters in model
  rsq                N8    0.0211853859   R-squared

  _MARRIED           N8    0.0074158463
  _ACSGENDER         N8               .
  _DIVISIONCDE       N8               .
  _INCOME            N8    0.0146399143
  _LOANHOME          N8               .
  _HHINCOME          N8               .
  _HOMEYRS           N8               .
  _OCUPASHN          N8    0.0064682383
  _AGE               N8               .
  _ACSADULTS         N8               .
  _RETAILCARD        N8               .
  _DEBITCARD         N8               .
  _REGIONCDE         N8    0.0131850397
  _CENINCOME         N8               .
  _HOMES             N8     -0.00549003
  _PURYER            N8               .
  _SINGLEWIDOW       N8               .
  _OWNHOME           N8    -0.011776015
  _NOCHILDREN        N8    -0.006234668
  _AGEGTR65          N8               .
  ---*/

    proc sort data=fbs_sllpos out=fbs_modelsrt;
    by ins descending rsq;
    run;

    data &out &bst(keep=ins rsq);
      keep cnt rsq nam val ins;
      set fbs_modelsrt;
      by ins;
      if first.ins then output &bst;
      cnt+1;
      if cnt < 101 then do;
          array vars[*] _:;
          put // 'rsquare=' rsq '  ' ins= 'variable model';
          do i=1 to dim(vars);
            nam=vname(vars[i]);
            val=vars[i];
            if not missing(vars[i]) then do;
              if strip(nam) ne "_IORC_" then do;
                 put @5 nam @40 vars[i];
                 output &out;
              end;
            end;
          end;
       end;
      if last.ins then cnt=0;
    run;

    /*---

    WORKX.LGS_BST

    INS       RSQ

     4     0.022258
     5     0.022867
     6     0.023633
     7     0.023925


    WORKX.LGS_MGMMODNRM total obs=2,200 (pos and neg parametes;

    Obs     INS       RSQ      CNT     NAM                VAL

    1        4     0.022258      1    _MARRIED         0.007618
    2        4     0.022258      1    _DIVISIONCDE     0.013457
    3        4     0.022258      1    _INCOME          0.011530
    4        4     0.022258      1    _LOANHOME        0.006932
    ....
    2194     7     0.023099    100    _MARRIED         0.007551
    2195     7     0.023099    100    _DIVISIONCDE     0.013498
    2196     7     0.023099    100    _INCOME          0.012299
    2197     7     0.023099    100    _LOANHOME        0.007462
    2198     7     0.023099    100    _HHINCOME        0.005252
    2199     7     0.023099    100    _CENINCOME      -0.009195
    2200     7     0.023099    100    _HOMES          -0.003579
    ---*/

%mend utl_mdlgetpos;
