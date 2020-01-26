%macro deleteMacArray(arr,start_index);                                                                                                 
  %local J;                                                                                                                             
  %if %symexist(&&arr.n) %then %do;                                                                                                     
     %do J = &start_index %to &&&arr.n;                                                                                                 
         %put *&arr.&J.*;                                                                                                               
         %symdel &arr.&J. / NOWARN;                                                                                                     
     %end;                                                                                                                              
  %end;                                                                                                                                 
  %symdel &arr.n / nowarn;                                                                                                              
 /* %deletemacarray(f_names,2) delete macros macrovar2-macrovar55  */                                                                   
%mend deleteMacArray;          
