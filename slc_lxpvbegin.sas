%macro slc_lxpvbegin;                                                           
  %utlfkil(c:/temp/lxpv_pgm.py);                                                
  %utlfkil(c:/temp/lxpv_pgm.log);                                               
  data _null_;                                                                  
    file "\\wsl$\Ubuntu/home/xlr82sas/temp/lxpv_pgm.py";                        
    input;                                                                      
    put _infile_;                                                               
%mend slc_lxpvbegin;                                                            
