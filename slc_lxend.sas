%macro slc_lxend;                                                               
    ;                                                                           
  run;                                                                          
  /* Remove Windows line endings */                                             
  data _null_;                                                                  
    call system('wsl sed -i "s/\r$//" /home/xlr82sas/temp/lx_pgm.sh');          
  run;                                                                          
  /* Make executable */                                                         
  data _null_;                                                                  
    call system('wsl chmod +x /home/xlr82sas/temp/lx_pgm.sh');                  
  run;                                                                          
  options noxwait noxsync;                                                      
  filename rut pipe "wsl bash -l -c /home/xlr82sas/temp/lx_pgm.sh";             
  data _null_;                                                                  
    file print;                                                                 
    infile rut recfm=v lrecl=32756;                                             
    input;                                                                      
    put _infile_;                                                               
    putlog _infile_;                                                            
  run;                                                                          
  data _null_;                                                                  
    infile rut;                                                                 
    input;                                                                      
    file "c:\temp\lx_pgm.log";                                                  
    put _infile_;                                                               
  run;                                                                          
%mend slc_lxend;                                                                
