%macro deleteSasmacN()                                                       
   /des="Delete all numberes sasmacr# libraries. does not delete sasnacr";   
                                                                             
   proc sql;                                                                 
     select                                                                  
        memname                                                              
     into                                                                    
        :_catNam separated by " "                                            
     from                                                                    
        sashelp.vscatlg                                                      
     where                                                                   
            libname =   "WORK"                                               
        and memname eqt "SASMAC"                                             
        and memname ne  "SASMACR"                                            
   ;quit;                                                                    
                                                                             
   %put &=sqlobs;                                                            
                                                                             
   %if &sqlobs %then %do;                                                    
      proc datasets lib=work mt=cat ;                                        
         delete &_catNam;                                                    
      run;quit;                                                              
   %end;                                                                     
                                                                             
%mend deleteSasmacN;                                                         
                                                                             
