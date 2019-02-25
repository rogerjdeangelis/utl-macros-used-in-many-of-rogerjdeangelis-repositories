%macro utl_aryFun(ary,len,fun=%str(**2))
/des="sum an array after appling an arbitrary function to each element";

  %let rc=%sysfunc(dosubl('
     data chk;
        length lst $32756;
        do idx=1 to symgetn("len");
          if notalpha(substr(symget("fun"),1,1)) then
            lst=catx(",",lst,cats("(",symget("ary"),"[",idx,"])",symget("fun")));
        else
            lst=catx(",",lst,cats(symget("fun"),"(",symget("ary"),"[",idx,"])"));

        end;
        call symputx("lst",lst,"G");
     run;quit;
     '));
  &lst

%mend utl_aryFun;