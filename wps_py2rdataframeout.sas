proc datasets lib=work                                                          
  nolist nodetails;                                                             
delete want;                                                                    
run;quit;                                                                       
options set=RHOME "D:\d451";                                                    
proc r;                                                                         
submit;                                                                         
want <- readRDS("d:/rds/pywant.rds")                                                         
head(want)                                                                      
endsubmit;                                                                      
import data=want r=want;                                                        
;quit;run;                                                                      
