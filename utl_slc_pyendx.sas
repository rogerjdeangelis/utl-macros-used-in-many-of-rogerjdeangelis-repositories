%macro utl_slc_pyendx;                                                          
run;quit; /*--- EXECUTE DATASTEP CREATES C:/TEMP/PY_PGM.PY ---*/                
/*-- JUST IN CASE A GLOBAL EXISTS ---*/                                         
%symdel return / nowarn;                                                        
/*--- GET MACRO VARIABLE CREATED IN TOP SLICE ---*/                             
data _null_;                                                                    
  infile "c:/temp/py_mac.sas" delimiter = ',' dsd;                              
  informat return resolve in out  py2r $255.;                                   
  input return resolve in out  py2r;                                            
  call symputx('return'  ,return  );                                            
  call symputx('resolve' ,resolve );                                            
  call symputx('in'      ,in      );                                            
  call symputx('out'     ,out     );                                            
  call symputx('py2r'    ,py2r    );                                            
run;quit;                                                                       
/*-- delete the only output slc sas dataset ---*/                               
proc datasets lib=work nolist nodetails;                                        
 delete &out;                                                                   
run;quit;                                                                       
/*--- RESOLVE MACRO TRIGGERS IN YOU PYTHON CODE ---*/                           
data _null_;                                                                    
  infile "c:/temp/py_pgm.py";                                                   
  input;                                                                        
  file "c:/temp/py_pgm.pyx";                                                    
  if _n_=1 then put "import pyperclip";                                         
  if "&resolve" ^= ""  then                                                     
     _infile_=resolve(_infile_);                                                
  put _infile_;                                                                 
  putlog _infile_;                                                              
run;quit;                                                                       
/*--- EXECUTE THE PYTHON PROGRAM                ---*/                           
options noxwait noxsync;                                                        
filename rut pipe  "d:\Python310\python.exe c:/temp/py_pgm.pyx 2> c:/temp/py_pgm.log";                                                                          
run;quit;                                                                                                                                                       
/*--- PRINT THE LOG TO OUTPUT WINDOW            ---*/                                                                                                           
data _null_;                                                                                                                                                    
  file print;                                                                                                                                                   
  infile rut;                                                                                                                                                   
  input;                                                                                                                                                        
  put _infile_;                                                                                                                                                 
  putlog _infile_;                                                                                                                                              
run;quit;                                                                                                                                                       
/*--- PRINT THE LOG TO LOG FILE                 ---*/                                                                                                           
data _null_;                                                                                                                                                    
  infile "c:/temp/py_pgm.log";                                                                                                                                  
  input;                                                                                                                                                        
  putlog _infile_;                                                                                                                                              
run;quit;                                                                                                                                                       
/*--- PYPERCLIP TEXT TO MACRO VARIABLE          ---*/                                                                                                           
%if "&return" ne ""  %then %do;                                                                                                                                 
  filename clp clipbrd ;                                                                                                                                        
  data _null_;                                                                                                                                                  
   infile clp;                                                                                                                                                  
   input;                                                                                                                                                       
   putlog "xxxxxx  " _infile_;                                                                                                                                  
   call symputx("&return.",_infile_,"G");                                                                                                                       
  run;quit;                                                                                                                                                     
%end;                                                                                                                                                           
/*--- PANDA DATAFRAME TO SLC SAS DATASET        ---*/                                                                                                           
data _null_;                                                                                                                                                    
  file "c:/temp/py_procr.sas";                                                                                                                                  
  put "options set=RHOME 'D:\r414';         ";                                                                                                                  
  put "proc r;                              ";                                                                                                                  
  put "submit;                              ";                                                                                                                  
  put "&out<-readRDS('&py2r')                ";                                                                                                                 
  put "head(&out)                           ";                                                                                                                  
  put "endsubmit;                           ";                                                                                                                  
  put "import data=&out r=&out;             ";                                                                                                                  
  put ";quit;run;                           ";                                                                                                                  
run;quit;                                                                                                                                                       
%include "c:/temp/py_procr.sas";                                                                                                                                
run;                                                                                                                                                            
%mend utl_slc_pyendx;                                                                                                                                           
