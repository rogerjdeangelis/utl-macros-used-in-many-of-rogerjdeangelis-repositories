%macro sqlpartitionx(dsn,by=team,minus=1)/                  
   des="Improved sqlpartition that maintains data order";   
 ( select                                                   
     *                                                      
     ,max(seq) as seq                                       
   from                                                     
     (select                                                
       *                                                    
      ,seq-min(seq) + 1 as partition                        
     from                                                   
       (select *, &minus*monotonic() as seq from &dsn)  
     group                                                  
       by &by )                                             
   group                                                    
       by &by, seq                                          
   having                                                   
       1=1)                                                 
%mend sqlpartitionx;                                        
