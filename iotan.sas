%macro iotan(too,from=1,by=1,delim=)            
  /des="create a delimited list of numbers";    
                                                
  %local idx res;                               
                                                
  %do idx=&from %to &too %by &by;               
                                                
   %if &idx ^= &too %then %do;                  
        %let res=&res &idx &delim;              
   %end;                                        
   %else %do;                                   
       %let res=&res &idx;                      
   %end;                                        
                                                
  %end;                                         
                                                
   %if &delim = %then %do;                      
      %sysfunc(compbl(&res))                    
   %end;                                        
   %else %do;                                   
       %sysfunc(compress(&res))                 
   %end;                                        
                                                
%mend iotan;                                    
