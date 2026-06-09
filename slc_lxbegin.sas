%macro slc_lxbegin;                                                             
  %utlfkil(c:/temp/lx_pgm.sh);                                                  
  %utlfkil(c:/temp/lx_pgm.log);                                                 
  data _null_;                                                                  
    file  "\\wsl$\Ubuntu/home/xlr82sas/temp/lx_pgm.sh";                         
    input;                                                                      
    put _infile_;                                                               
%mend slc_lxbegin;                                                              
