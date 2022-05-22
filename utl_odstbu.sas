%macro utl_odstbu(outdsn,bars=5,firstobs=2);                                                                                            
                                                                                                                                        
   %if %qupcase(&outdsn)=SETUP %then %do;                                                                                               
                                                                                                                                        
        filename _tmp1_ clear;  * just in case;                                                                                         
                                                                                                                                        
        %utlfkil(%sysfunc(pathname(work))/_tmp1_.txt);                                                                                  
                                                                                                                                        
        filename _tmp1_ "%sysfunc(pathname(work))/_tmp1_.txt";                                                                          
                                                                                                                                        
        %let _ps_= %sysfunc(getoption(ps));                                                                                             
        %let _fc_= %sysfunc(getoption(formchar));                                                                                       
                                                                                                                                        
        OPTIONS ls=max ps=32756  FORMCHAR='|'  nodate nocenter;                                                                         
                                                                                                                                        
        title; footnote;                                                                                                                
                                                                                                                                        
        proc printto print=_tmp1_;                                                                                                      
        run;quit;                                                                                                                       
                                                                                                                                        
   %end;                                                                                                                                
   %else %do;                                                                                                                           
                                                                                                                                        
        /* %let outdsn=tst; %let datarow=3; */                                                                                          
                                                                                                                                        
        proc printto;                                                                                                                   
        run;quit;                                                                                                                       
                                                                                                                                        
        %utlfkil(%sysfunc(pathname(work))/_tmp2_.txt);                                                                                  
                                                                                                                                        
        *filename _tmp2_  "%sysfunc(pathname(work))/_tmp2_.txt";                                                                        
                                                                                                                                        
        proc datasets lib=work nolist;  *just in case;                                                                                  
         delete &outdsn;                                                                                                                
        run;quit;                                                                                                                       
                                                                                                                                        
        proc printto print="%sysfunc(pathname(work))/_tmp2_.txt";                                                                       
        run;quit;                                                                                                                       
                                                                                                                                        
        data _null_;                                                                                                                    
          retain n 0;                                                                                                                   
          infile _tmp1_ length=l firstobs=&firstobs;                                                                                    
          input lyn $varying32756. l;                                                                                                   
          file print titles;                                                                                                            
          if countc(lyn,'|')=&bars then do;                                                                                             
              putlog lyn;                                                                                                               
              put lyn;                                                                                                                  
          end;                                                                                                                          
        run;quit;                                                                                                                       
                                                                                                                                        
        proc printto;                                                                                                                   
        run;quit;                                                                                                                       
                                                                                                                                        
        proc import                                                                                                                     
           datafile="%sysfunc(pathname(work))/_tmp2_.txt"                                                                               
           dbms=dlm                                                                                                                     
           out=&outdsn(drop=var:)                                                                                                       
           replace;                                                                                                                     
           delimiter='|';                                                                                                               
           getnames=yes;                                                                                                                
        run;quit;                                                                                                                       
                                                                                                                                        
        filename _tmp1_ clear;                                                                                                          
        filename _tmp2_ clear;                                                                                                          
                                                                                                                                        
        * turn off for production;                                                                                                      
        %*utlfkil(%sysfunc(pathname(work))/_tmp1_.txt);                                                                                 
        %*utlfkil(%sysfunc(pathname(work))/_tmp2_.txt);                                                                                 
                                                                                                                                        
        proc datasets lib = work nodetails nolist;                                                                                      
          modify &outdsn ;                                                                                                              
            attrib _all_ label = "" ;                                                                                                   
            format _all_;                                                                                                               
            informat _all_;                                                                                                             
          run ;                                                                                                                         
        quit ;                                                                                                                          
   %end;                                                                                                                                
                                                                                                                                        
%mend utl_odstbu;                                                                                                                       
                                   
