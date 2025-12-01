%macro wps_psbegin;                                                             
%utlfkil(c:/temp/ps_pgm.ps1);                                                   
%utlfkil(c:/temp/ps_pgm.log);                                                   
filename ft15f001 "c:/temp/ps_pgm.ps1";                                         
data _null_;                                                                    
 file ft15f001;                                                                 
 input;                                                                         
 put _infile_;                                                                  
%mend wps_psbegin;                                                              
