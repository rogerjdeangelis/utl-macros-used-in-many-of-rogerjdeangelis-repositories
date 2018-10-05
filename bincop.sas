%macro BinCop(                                                                                                                                                  
              in=\\filesrv04\stat\peggcsf\sd01\meta\datamart\bonepain_2008\docs\rogerdeangelis\bne.xls                                                          
              ,out=c:\pis\bne.xls                                                                                                                               
             ) / des="Copy a binary file";                                                                                                                      
data _null_;                                                                                                                                                    
  infile "&in" recfm=n;                                                                                                                                         
  file "&out" recfm=n;                                                                                                                                          
  input byt $char1. @@;                                                                                                                                         
  put byt $char1. @@;                                                                                                                                           
run;                                                                                                                                                            
%mend BinCop;                                                                                                                                                   
             
