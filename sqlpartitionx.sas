%macro sqlpartitionx(dsn,by=team,minus=1)/                  
   des="Improved sqlpartition that maintains data order";   
 ( select                                                   
     *                                                      
     ,max(seq) as seq                                       
   from                                                     
     (select                                                
        *                                                   
        %if &minus=1 %then %do;                             
           %str(,seq-min(seq) + 1 as partition)             
        %end;                                               
        %else %do;                                          
           %str(, seq - min(seq) + 1 as partition)          
        %end;                                               
     from                                                   
       (select *, &minus*monotonic() as seq from sd1.have)  
     group                                                  
       by &by )                                             
   group                                                    
       by &by, seq                                          
   having                                                   
       1=1)                                                 
%mend sqlpartitionx;                                        
