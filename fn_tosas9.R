   fn_tosas9<-function(dataf=NULL) {
   dfstr<-deparse(substitute(dataf));
   file.remove(paste0("c:\\temp\\",dfstr,".sas7bdat"));
   file.remove("c:\\temp\\cmds.stcmd");
   saveRDS(dataf, file="c:/temp/rdsdat.rds");
   fileConn<-file("c:/temp/comands.txt");
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
   ,"copy  C:/temp/rdsdat.rds sas9 C:/temp/chileancredit.sas7bdat -T<chileancredit"),fileConn);
    writeLines( "c:/temp/comands.txt");
    close(fileConn);
   file.show("c:/temp/comands.txt");
   lines <- readLines("c:/temp/commands.stcmd");
   for (line in lines) {
     modified_line <- sub(pattern = "chileancredit", replace = dfstr, x = line);
     modified_line <- sub(pattern = "chileancredit", replace = dfstr, x = modified_line);
     print(modified_line);
     write(modified_line, file = "c:/temp/cmds.stcmd", append = TRUE);
   };
   system(paste("c:\\PROGRA~1\\StatTransfer16-64\\st.exe",
     "c:/temp/cmds.stcmd"), wait = FALSE);
   quit(save="no");
    };
