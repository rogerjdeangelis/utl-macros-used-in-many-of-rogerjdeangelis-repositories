 fn_tosas9x<-function(                                                          
   inp    =NULL                                                                 
  ,outlib =NULL                                                                 
  ,outdsn =NULL                                                                 
  )                                                                             
 {                                                                              
 rds <- tempfile(fileext = ".rds");                                             
 saveRDS(inp, file = rds);                                                      
 stcmd <- tempfile(fileext = ".stcmd");                                         
 writeLines(c(                                                                  
 "set numeric-names      n              "                                       
,"set log-level          e              "                                       
,"set in-encoding        system         "                                       
,"set out-encoding       system         "                                       
,"set enc-errors         sub            "                                       
,"set enc-sub-char       _              "                                       
,"set enc-error-limit    100            "                                       
,"set var-case-ci        preserve-always"                                       
,"set preserve-str-widths n             "                                       
,"set preserve-num-widths n             "                                       
,"set recs-to-optimize   all            "                                       
,"set factor-as-string   n              "                                       
,"set sas-date-fmt       mmddyy         "                                       
,"set sas-time-fmt       time           "                                       
,"set sas-datetime-fmt   datetime       "                                       
,"set write-file-label   none           "                                       
,"set write-sas-fmts     n              "                                       
,"set sas-outrep         windows_64     "                                       
,"set write-old-ver      18             "                                       
,paste("copy",rds,"sas9",                                                       
  paste0(outlib,outdsn,".sas7bdat"),"-T<outdsn")                                
,"quit"),stcmd);                                                                
 unlink(paste0(outlib,outdsn,".sas7bdat"));                                     
 system(paste("c:/PROGRA~1/StatTransfer17-64/st.exe"                            
   ,stcmd));                                                                    
  };                                                                            
