%macro slc_plbegin / des="drop down to perl";;                                  
%utlfkil(c:/temp/pl_pgm.txt);                                                   
%utlfkil(c:/temp/pl_log.txt);                                                   
data _null_;                                                                    
  file "c:/temp/pl_pgm.txt";                                                    
  input;                                                                        
  put _infile_;                                                                 
%mend slc_plbegin;                                                              
