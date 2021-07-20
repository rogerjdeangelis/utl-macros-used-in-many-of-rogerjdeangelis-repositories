%macro utlvenn                                                                                    
     (                                                                                            
      uinmema=sashelp.class                                                                       
     ,uinmemb=sashelp.classfit                                                                    
     ,uvara  =name                                                                                
     ,uvarb  =name                                                                                
     ) / des = "Venn diagram for two tables";                                                     
                                                                                                  
  %let uinmem1 = %upcase( &uinmema);                                                              
  %let uinmem2 = %upcase( &uinmemb);                                                              
                                                                                                  
  %let uinmema = %upcase( &uinmema);                                                              
  %let uinmemb = %upcase( &uinmemb);                                                              
                                                                                                  
  %let uvara   = %upcase( &uvara  );                                                              
  %let uvarb   = %upcase( &uvarb  );                                                              
                                                                                                  
  %if %index(&uinmem1,%str(.)) = 0 %then %do;                                                     
        %let inliba=WORK;                                                                         
  %end;                                                                                           
  %else %do;                                                                                      
       %let inliba  = %scan(&uinmem1,1,%str(.));                                                  
       %let uinmema = %scan(&uinmem1,2,%str(.));                                                  
  %end;                                                                                           
  %if %index(&uinmem2,%str(.)) = 0 %then %do;                                                     
       %let inlibb=WORK;                                                                          
  %end;                                                                                           
  %else %do;                                                                                      
       %let inlibb  = %scan(&uinmem2,1,%str(.));                                                  
       %let uinmemb = %scan(&uinmem2,2,%str(.));                                                  
  %end;                                                                                           
                                                                                                  
/*----------------------------------------------*\                                                
|  SQL code to get counts                        |                                                
|                                                |                                                
|   udsta    = distint values is set a           |                                                
|   udstb    = distint values is set b           |                                                
|                                                |                                                
|   unota    = values not in a                   |                                                
|   unotb    = values not in b                   |                                                
|                                                |                                                
|   uaib     = values in intersection            |                                                
|                                                |                                                
\*----------------------------------------------*/                                                
                                                                                                  
proc sql noprint;                                                                                 
                                                                                                  
 select memlabel , nobs                                                                           
  into :ulaba , :uina                                                                             
  from dictionary.tables                                                                          
  where libname="&inliba" and memname="&uinmema";                                                 
                                                                                                  
 select memlabel , nobs                                                                           
  into :ulabb , :uinb                                                                             
  from dictionary.tables                                                                          
  where libname="&inlibb" and memname="&uinmemb";                                                 
                                                                                                  
                                                                                                  
 select count(distinct &uvara) into :udsta                                                        
  from &uinmem1;                                                                                  
                                                                                                  
 select count(distinct &uvarb) into :udstb                                                        
  from &uinmem2;                                                                                  
                                                                                                  
                                                                                                  
 select count(distinct &uvara) into :unotb                                                        
  from &uinmem1                                                                                   
  where &uvara not in                                                                             
   (select &uvarb as &uvara                                                                       
    from &uinmem2);                                                                               
                                                                                                  
 select count(distinct &uvarb) into :unota                                                        
  from &uinmem2                                                                                   
  where &uvarb not in                                                                             
   (select &uvara as &uvarb                                                                       
    from &uinmem1);                                                                               
                                                                                                  
                                                                                                  
 select count(distinct &uvara) into :uaib                                                         
  from &uinmem1                                                                                   
  where &uvara in                                                                                 
   (select &uvarb as &uvara                                                                       
    from &uinmem2);                                                                               
                                                                                                  
quit;                                                                                             
run;                                                                                              
                                                                                                  
%let udstab=%eval(&unota + &unotb + &uaib);   /* total distinct*/                                 
%let uaub=%eval(&uina + &uinb);               /* a union b     */                                 
%put unota=&unota;                            /* not in  a     */                                 
%put unotb=&unotb;                            /* not in  b     */                                 
%put uaib=&uaib;                              /* a intersect b */                                 
%put uina=&uina;                              /* in a          */                                 
%put uinb=&uinb;                              /* in b          */                                 
                                                                                                  
data _null_;                                                                                      
                                                                                                  
     uaub=%eval(&uina + &uinb);                                                                   
     unota=&unota;                                                                                
     unotb=&unotb;                                                                                
     udsta=&udsta;                                                                                
     udstb=&udstb;                                                                                
     udstab=&udstab;                                                                              
     uaib=&uaib;                                                                                  
     uina=&uina;                                                                                  
     uinb=&uinb;                                                                                  
                                                                                                  
 put #02 @10 "Set A is %trim(%left(&uinmem1))  Element=%trim(%left(&uvara))";                     
 put #03 @10 "Set B is %trim(%left(&uinmem2))  Element=%trim(%left(&uvarb))";                     
 put #05 @26 " A Union B "@;                                                                      
 put #06 @22 uaub comma12. @;                                                                     
 put #07 @22 udstab comma12.@;                                                                    
 put #08 @20 "&uinmema" @35 "&uinmemb"@;                                                          
 put #09 @16 uina  comma12. @31 uinb  comma12. @45 "OBS";                                         
 put #10 @16 udsta comma12. @31 udstb comma12. @45 "DISTINCTS";                                   
 put #12 @3 "                  *8888888888*     *88888888*             "@;                        
 put #13 @3 "                 8            8   8          8            "@;                        
 put #14 @3 "                8              8 8            8           "@;                        
 put #15 @3 "               8                8              8          "@;                        
 put #16 @3 "              8               8  8              8         "@;                        
 put #17 @3 "             8              8     8              8        "@;                        
 put #18 @3 "            8              8       8              8       "@;                        
 put #19 @3 "           8              8         8              8      "@;                        
 put #20 @3 "          8              8           8              8     "@;                        
 put #21 @3 "         8              8             8              8    "@;                        
 put #22 @3 "         8              8             8              8    "@;                        
 put #23 @3 "         8              8             8              8    "@;                        
 put #23 @06 unotb comma12.  @22 uaib comma12. @39 unota comma12. @;                              
 put #23 @3 "         8"@;                                                                        
 put #24 @3 "         8              8             8              8    "@;                        
 put #25 @3 "         8              8             8              8    "@;                        
 put #26 @3 "         8              8             8              8    "@;                        
 put #27 @3 "          8              8           8              8     "@;                        
 put #28 @3 "           8              8         8              8      "@;                        
 put #29 @3 "            8              8       8              8       "@;                        
 put #30 @3 "             8              8     8              8        "@;                        
 put #31 @3 "              8              8   8              8         "@;                        
 put #32 @3 "               8              8 8              8          "@;                        
 put #33 @3 "                8              8              8           "@;                        
 put #34 @3 "                 8            8 8            8            "@;                        
 put #35 @3 "                  *8888888888*   *8888888888*             "@;                        
 put #36 @3 "                                                          "@;                        
 put #37 @3 "                                                           "@;                       
 put #38 @3 "                                                           "@;                       
                                                                                                  
stop;                                                                                             
run;                                                                                              
                                                                                                  
%mend utlvenn;                                                                                    
                                                                                                  
                                                                             
