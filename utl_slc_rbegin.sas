%macro utl_slc_rbegin;                                                          
data _null_;                                                                    
 infile cards4 eof=done truncover;                                              
 file "c:/temp/r_pgm.sas";                                                      
 input;                                                                         
 put _infile_;                                                                  
 putlog _infile_;                                                               
 return;                                                                        
 done:                                                                          
   put "save.image(file = 'd:/wpswrk/workspace.RData')";                        
%mend utl_slc_rbegin;                                                           
