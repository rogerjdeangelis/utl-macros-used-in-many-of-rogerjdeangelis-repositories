%macro deleteMacArray(arr,start_index); 
  %local J;                             
  %do J = 1 %to &&&arr.n;               
    %put *&&&arr.&J.*;                  
    %symdel &arr.&J. / NOWARN;          
  %end;                                 
  %symdel &arr.n / nowarn;              
%mend deleteMacArray;                   
