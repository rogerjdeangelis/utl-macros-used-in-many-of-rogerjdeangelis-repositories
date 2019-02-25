%macro utl_aryFil(ary,len,fun=%str(**2))/                                        
   des="sum an array after appling an arbitrary function to each element";       
                                                                                 
  %let rc=%sysfunc(dosubl('                                                      
     data chk;                                                                   
        length lst $32756;                                                       
        do idx=1 to symgetn("len");                                              
          ara=cats(symget("ary"),"[",idx,"]");                                   
          if notalpha(substr(symget("fun"),1,1)) then do;                        
            lst=cats(lst,ara,'=',ara,symget("fun"),";");                         
          end;                                                                   
          else do;                                                               
            lst=cats(lst,ara,'=',symget("fun"),"(",ara,");");                    
          end;                                                                   
        end;                                                                     
        call symputx("lst",lst,"G");                                             
     run;quit;                                                                   
     '));                                                                        
  &lst                                                                           
                                                                                 
%mend utl_aryFil;                                                                
