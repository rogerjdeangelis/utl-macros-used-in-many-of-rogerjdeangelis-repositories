%macro utl_slc_pybeginx(                                                        
      return=                         /*--- macro var  ---*/                    
     ,resolve=Y                       /*--- resolve mac---*/                    
     ,in=d:/sd1/have.sas7bdat         /*--- inp data   ---*/                    
     ,out=tbl                         /*--- out data   ---*/                    
     ,py2r=c:/temp/py_dataframe.rds   /* py 2 r data   ---*/                    
     );                                                                         
 /*--- CLEAR FILES NEEDED FOR THE MACROS         ---*/                          
 %utlfkil(c:/temp/py_pgm.py );        /*--- raw python ---*/                    
 %utlfkil(c:/temp/py_pgm.pyx);        /*--- resolved   ---*/                    
 %utlfkil(c:/temp/py_pgm.log);        /*--- pyhton log ---*/                    
 %utlfkil(c:/temp/py_mac.sas);        /*--- mac vars   ---*/                    
 %utlfkil(c:/temp/py_dataframe.rds ); /*--- r rds file ---*/                    
 %utlfkil(c:/temp/py_procr.sas );     /*--- py to slc  ---*/                    
 /*--- USE A FILE TO TRANSFER MACRO VARS TO BOTTOM SANDWICH ---*/               
 /*--- RATHER DO THIS THEN USE GLOBAL MACRO VARIABLES       ---*/               
 data _null_;                                                                   
  input;                                                                        
  file "c:/temp/py_pgm.py";                                                     
  put _infile_;                                                                 
 if _n_=1 then do;                                                              
    file "c:/temp/py_mac.sas"  dsd;                                             
    put "&return " ',' "&resolve " ',' "&in" ',' "&out" ',' "&py2r" ;           
 end;                                                                           
%mend utl_slc_pybeginx;                                                         
