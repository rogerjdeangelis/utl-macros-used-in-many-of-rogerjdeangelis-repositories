%macro utl_checker(sysbin=,outdsn=);                                                                         
                                                                                                             
 %put %sysfunc(ifc(%sysevalf(%superq(sysbin )=,boolean),**** Please Provide the sysbin value    ****,));     
 %put %sysfunc(ifc(%sysevalf(%superq(outdsn )=,boolean),**** Please Provide an output dataset    ****,));    
                                                                                                             
  %let res= %eval                                                                                            
  (                                                                                                          
      %sysfunc(ifc(%sysevalf(%superq(sysbin )=,boolean),1,0))                                                
    + %sysfunc(ifc(%sysevalf(%superq(outdsn )=,boolean),1,0))                                                
  );                                                                                                         
                                                                                                             
   %if &res = 0 %then %do;                                                                                   
       %put do some work;                                                                                    
   %end;                                                                                                     
                                                                                                             
%mend utl_checker;                                                                                           
                                                                                                             
