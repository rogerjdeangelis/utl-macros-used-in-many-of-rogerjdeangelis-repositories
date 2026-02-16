%macro slc_psbegin;                                                             
%utlfkil(c:/temp/ps_pgm.ps1);                                                   
%utlfkil(c:/temp/ps_pgm.log);                                                   
data _null_;                                                                    
  file "c:/temp/ps_pgm.ps1";                                                    
  input;                                                                        
  put _infile_;                                                                 
%mend slc_psbegin;                                                              
