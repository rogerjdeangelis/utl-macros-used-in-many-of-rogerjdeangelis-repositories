%macro wps_py2sastable(                                                         
   inp=d:/rds/pywant.rds                                                        
  ,out=rwant )/des="convert py created R rds file to sas dataset";              
                                                                                
  %utlfkil(c:/wpsoto/wps_py2rdataframeout.sas);                                 
                                                                                
  data _null_;                                                                  
    infile "c:/wpsoto/wps_py2rdataframe.sas";                                   
    file "c:/wpsoto/wps_py2rdataframeout.sas";                                  
    input;                                                                      
    _infile_=resolve(_infile_);                                                 
    put _infile_;                                                               
    putlog _infile_;                                                            
  run;quit;                                                                     
                                                                                
  %include "c:/wpsoto/wps_py2rdataframeout.sas";                                
                                                                                
proc print data=rwant(obs=5);                                                   
run;quit;                                                                       
                                                                                
%mend wps_py2sastable;                                                          
